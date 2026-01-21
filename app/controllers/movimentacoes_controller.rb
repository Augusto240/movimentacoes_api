class MovimentacoesController < ApplicationController
  
  # ===========================================
  # LISTAR TODAS AS MOVIMENTAÇÕES
  # ===========================================
  def index
    @movimentacoes = Movimentacao.includes(:correntista, :beneficiario)
                                 .order(data_operacao: :desc)
    
    render json: format_movimentacoes(@movimentacoes)
  end
  
  # ===========================================
  # EXTRATO DO CORRENTISTA
  # ===========================================
  def extrato
    correntista = Correntista.find_by(correntista_id: params[:correntista_id])

    unless correntista
      render json: { error: "Correntista não encontrado" }, status: :not_found
      return
    end

    movimentacoes = Movimentacao
                      .includes(:beneficiario)
                      .where(correntista_id: correntista.correntista_id)
                      .order(data_operacao: :desc)

    render json: {
      correntista: {
        id: correntista.correntista_id,
        nome: correntista.nome_correntista,
        saldo: correntista.saldo.to_f
      },
      movimentacoes: movimentacoes.map do |m|
        {
          movimentacao_id: m.movimentacao_id,
          tipo_operacao: m.tipo_operacao == 'C' ? 'Crédito' : 'Débito',
          data_operacao: m.data_operacao&.strftime("%Y-%m-%d %H:%M:%S"),
          descricao: m.descricao,
          valor_operacao: m.valor_operacao.to_f,
          beneficiario: m.beneficiario.present? ? {
            id: m.beneficiario.correntista_id,
            nome: m.beneficiario.nome_correntista
          } : nil
        }
      end
    }
  end

  # ===========================================
  # OPERAÇÃO DE PAGAMENTO
  # ===========================================
  def pagar
    @correntista = Correntista.find_by(correntista_id: params[:correntista_id])
    valor = params[:valor].to_f
    descricao = params[:descricao].presence || "Pagamento"
    
    # Validações
    return render_error("Correntista não encontrado", :not_found) if @correntista.nil?
    return render_error("Valor inválido") if valor <= 0
    return render_error("Saldo insuficiente") unless @correntista.saldo_suficiente?(valor)
    
    ActiveRecord::Base.transaction do    
      @movimentacao = Movimentacao.create!(
        tipo_operacao: 'D',
        correntista_id: @correntista.correntista_id,
        valor_operacao: valor,
        data_operacao: Time.current,
        descricao: "Pagamento: #{descricao}"
      )
            
      @correntista.debitar!(valor)
      
      # Broadcast via WebSocket
      broadcast_movimentacao(@movimentacao, "Pagamento de #{format_currency(valor)} realizado")
      
      render json: {
        mensagem: "Pagamento realizado com sucesso",
        movimentacao: format_movimentacoes([@movimentacao]).first,
        saldo_atual: @correntista.saldo.to_f
      }
    end
  rescue StandardError => e
    render_error("Erro ao realizar pagamento: #{e.message}")
  end

  # ===========================================
  # OPERAÇÃO DE TRANSFERÊNCIA
  # ===========================================
  def transferir
    @correntista = Correntista.find_by(correntista_id: params[:correntista_id])
    @beneficiario = Correntista.find_by(correntista_id: params[:beneficiario_id])
    valor = params[:valor].to_f
    
    # Validações
    return render_error("Correntista não encontrado", :not_found) if @correntista.nil?
    return render_error("Beneficiário não encontrado", :not_found) if @beneficiario.nil?
    return render_error("Origem e destino não podem ser iguais") if @correntista.correntista_id == @beneficiario.correntista_id
    return render_error("Valor inválido") if valor <= 0
    return render_error("Saldo insuficiente") unless @correntista.saldo_suficiente?(valor)
    
    ActiveRecord::Base.transaction do      
      # Débito na conta de origem
      @movimentacao = Movimentacao.create!(
        tipo_operacao: 'D',
        correntista_id: @correntista.correntista_id,
        valor_operacao: valor,
        data_operacao: Time.current,
        descricao: "Transferência para #{@beneficiario.nome_correntista}",
        beneficiario_id: @beneficiario.correntista_id
      )
      
      # Crédito na conta de destino
      Movimentacao.create!(
        tipo_operacao: 'C',
        correntista_id: @beneficiario.correntista_id,
        valor_operacao: valor,
        data_operacao: Time.current,
        descricao: "Transferência recebida de #{@correntista.nome_correntista}"
      )
            
      @correntista.debitar!(valor)
      @beneficiario.creditar!(valor)
      
      # Broadcast via WebSocket
      broadcast_movimentacao(@movimentacao, "Transferência de #{format_currency(valor)} realizada")
      
      render json: {
        mensagem: "Transferência realizada com sucesso",
        movimentacao: format_movimentacoes([@movimentacao]).first,
        saldo_atual: @correntista.saldo.to_f
      }
    end
  rescue StandardError => e
    render_error("Erro ao realizar transferência: #{e.message}")
  end

  # ===========================================
  # OPERAÇÃO DE SAQUE
  # ===========================================
  def sacar
    @correntista = Correntista.find_by(correntista_id: params[:correntista_id])
    valor = params[:valor].to_f
    
    # Validações
    return render_error("Correntista não encontrado", :not_found) if @correntista.nil?
    return render_error("Valor inválido") if valor <= 0
    return render_error("Saldo insuficiente") unless @correntista.saldo_suficiente?(valor)
    
    ActiveRecord::Base.transaction do
      @movimentacao = Movimentacao.create!(
        tipo_operacao: 'D',
        correntista_id: @correntista.correntista_id,
        valor_operacao: valor,
        data_operacao: Time.current,
        descricao: "Saque"
      )
      
      @correntista.debitar!(valor)
      
      # Broadcast via WebSocket
      broadcast_movimentacao(@movimentacao, "Saque de #{format_currency(valor)} realizado")
      
      render json: {
        mensagem: "Saque realizado com sucesso",
        movimentacao: format_movimentacoes([@movimentacao]).first,
        saldo_atual: @correntista.saldo.to_f
      }
    end
  rescue StandardError => e
    render_error("Erro ao realizar saque: #{e.message}")
  end
  
  # ===========================================
  # OPERAÇÃO DE DEPÓSITO
  # ===========================================
  def depositar
    @correntista = Correntista.find_by(correntista_id: params[:correntista_id])
    valor = params[:valor].to_f
    
    # Validações
    return render_error("Correntista não encontrado", :not_found) if @correntista.nil?
    return render_error("Valor inválido") if valor <= 0
    
    ActiveRecord::Base.transaction do
      @movimentacao = Movimentacao.create!(
        tipo_operacao: 'C',
        correntista_id: @correntista.correntista_id,
        valor_operacao: valor,
        data_operacao: Time.current,
        descricao: "Depósito em conta"
      )
      
      @correntista.creditar!(valor)
      
      # Broadcast via WebSocket
      broadcast_movimentacao(@movimentacao, "Depósito de #{format_currency(valor)} realizado")
      
      render json: {
        mensagem: "Depósito realizado com sucesso",
        movimentacao: format_movimentacoes([@movimentacao]).first,
        saldo_atual: @correntista.saldo.to_f
      }
    end
  rescue StandardError => e
    render_error("Erro ao realizar depósito: #{e.message}")
  end
  
  private

  # ===========================================
  # MÉTODOS AUXILIARES
  # ===========================================

  # Formata lista de movimentações para JSON
  def format_movimentacoes(movimentacoes)
    movimentacoes.map do |mov|
      {
        movimentacao_id: mov.movimentacao_id,
        tipo_operacao: mov.tipo_operacao,
        correntista: {
          id: mov.correntista.correntista_id,
          nome: mov.correntista.nome_correntista
        },
        beneficiario: mov.beneficiario.present? ? {
          id: mov.beneficiario.correntista_id,
          nome: mov.beneficiario.nome_correntista
        } : nil,
        valor_operacao: mov.valor_operacao.to_f,
        data_operacao: mov.data_operacao&.strftime("%Y-%m-%d %H:%M:%S"),
        descricao: mov.descricao
      }
    end
  end

  # Renderiza erro padronizado
  def render_error(message, status = :unprocessable_entity)
    render json: { error: message }, status: status
  end

  # Formata valor em reais
  def format_currency(value)
    "R$ #{'%.2f' % value}"
  end

  # Envia notificação via WebSocket (Action Cable)
  def broadcast_movimentacao(movimentacao, mensagem)
    ActionCable.server.broadcast(
      "movimentacoes_channel",
      {
        tipo: movimentacao.tipo_operacao == 'C' ? 'credito' : 'debito',
        movimentacao_id: movimentacao.movimentacao_id,
        correntista_id: movimentacao.correntista_id,
        valor: movimentacao.valor_operacao.to_f,
        descricao: mensagem,
        timestamp: Time.current.iso8601
      }
    )
    
    # Também envia para o canal específico do correntista
    ActionCable.server.broadcast(
      "movimentacoes_correntista_#{movimentacao.correntista_id}",
      {
        tipo: movimentacao.tipo_operacao == 'C' ? 'credito' : 'debito',
        movimentacao_id: movimentacao.movimentacao_id,
        valor: movimentacao.valor_operacao.to_f,
        descricao: mensagem,
        timestamp: Time.current.iso8601
      }
    )
  end
end