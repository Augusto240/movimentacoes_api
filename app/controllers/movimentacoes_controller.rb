class MovimentacoesController < ApplicationController
  
  def index
    @movimentacoes = Movimentacao.includes(:correntista, :beneficiario)
                                 .order(:data_operacao)
    
    render json: format_movimentacoes(@movimentacoes)
  end
    
  def extrato
    @correntista = Correntista.find_by(correntista_id: params[:correntista_id])
    
    if @correntista
      @movimentacoes = @correntista.movimentacoes.includes(:beneficiario).order(data_operacao: :desc)
      render json: {
        correntista: {
          id: @correntista.correntista_id,
          nome: @correntista.nome_correntista,
          saldo: @correntista.saldo
        },
        movimentacoes: format_movimentacoes(@movimentacoes)
      }
    else
      render json: { error: "Correntista não encontrado" }, status: :not_found
    end
  end
    
  def pagar
    @correntista = Correntista.find_by(correntista_id: params[:correntista_id])
    valor = params[:valor].to_f
    descricao = params[:descricao]
    
    if @correntista.nil?
      render json: { error: "Correntista não encontrado" }, status: :not_found
      return
    end
    
    if valor <= 0
      render json: { error: "Valor inválido" }, status: :unprocessable_entity
      return
    end
    
    if @correntista.saldo < valor
      render json: { error: "Saldo insuficiente" }, status: :unprocessable_entity
      return
    end
    
    ActiveRecord::Base.transaction do    
      @movimentacao = Movimentacao.create!(
        tipo_operacao: 'D',
        correntista_id: @correntista.correntista_id,
        valor_operacao: valor,
        data_operacao: Time.now,
        descricao: "Pagamento: #{descricao}"
      )
            
      @correntista.update!(saldo: @correntista.saldo - valor)
      
      render json: {
        mensagem: "Pagamento realizado com sucesso",
        movimentacao: format_movimentacoes([@movimentacao]).first,
        saldo_atual: @correntista.saldo
      }
    end
  rescue => e
    render json: { error: "Erro ao realizar pagamento: #{e.message}" }, status: :unprocessable_entity
  end
    
  def transferir
    @correntista = Correntista.find_by(correntista_id: params[:correntista_id])
    @beneficiario = Correntista.find_by(correntista_id: params[:beneficiario_id])
    valor = params[:valor].to_f
    
    if @correntista.nil? || @beneficiario.nil?
      render json: { error: "Correntista ou beneficiário não encontrado" }, status: :not_found
      return
    end
    
    if valor <= 0
      render json: { error: "Valor inválido" }, status: :unprocessable_entity
      return
    end
    
    if @correntista.saldo < valor
      render json: { error: "Saldo insuficiente" }, status: :unprocessable_entity
      return
    end
    
    ActiveRecord::Base.transaction do      
      @movimentacao = Movimentacao.create!(
        tipo_operacao: 'D',
        correntista_id: @correntista.correntista_id,
        valor_operacao: valor,
        data_operacao: Time.now,
        descricao: "Transferência",
        correntista_beneficiario_id: @beneficiario.correntista_id
      )
            
      @movimentacao_beneficiario = Movimentacao.create!(
        tipo_operacao: 'C',
        correntista_id: @beneficiario.correntista_id,
        valor_operacao: valor,
        data_operacao: Time.now,
        descricao: "Transferência recebida de #{@correntista.nome_correntista}"
      )
            
      @correntista.update!(saldo: @correntista.saldo - valor)
      @beneficiario.update!(saldo: @beneficiario.saldo + valor)
      
      render json: {
        mensagem: "Transferência realizada com sucesso",
        movimentacao: format_movimentacoes([@movimentacao]).first,
        saldo_atual: @correntista.saldo
      }
    end
  rescue => e
    render json: { error: "Erro ao realizar transferência: #{e.message}" }, status: :unprocessable_entity
  end
    
  def sacar
    @correntista = Correntista.find_by(correntista_id: params[:correntista_id])
    valor = params[:valor].to_f
    
    if @correntista.nil?
      render json: { error: "Correntista não encontrado" }, status: :not_found
      return
    end
    
    if valor <= 0
      render json: { error: "Valor inválido" }, status: :unprocessable_entity
      return
    end
    
    if @correntista.saldo < valor
      render json: { error: "Saldo insuficiente" }, status: :unprocessable_entity
      return
    end
    
    ActiveRecord::Base.transaction do
      @movimentacao = Movimentacao.create!(
        tipo_operacao: 'D',
        correntista_id: @correntista.correntista_id,
        valor_operacao: valor,
        data_operacao: Time.now,
        descricao: "Saque"
      )
      
      @correntista.update!(saldo: @correntista.saldo - valor)
      
      render json: {
        mensagem: "Saque realizado com sucesso",
        movimentacao: format_movimentacoes([@movimentacao]).first,
        saldo_atual: @correntista.saldo
      }
    end
  rescue => e
    render json: { error: "Erro ao realizar saque: #{e.message}" }, status: :unprocessable_entity
  end
  
  def depositar
    @correntista = Correntista.find_by(correntista_id: params[:correntista_id])
    valor = params[:valor].to_f
    
    if @correntista.nil?
      render json: { error: "Correntista não encontrado" }, status: :not_found
      return
    end
    
    if valor <= 0
      render json: { error: "Valor inválido" }, status: :unprocessable_entity
      return
    end
    
    ActiveRecord::Base.transaction do
      @movimentacao = Movimentacao.create!(
        tipo_operacao: 'C',
        correntista_id: @correntista.correntista_id,
        valor_operacao: valor,
        data_operacao: Time.now,
        descricao: "Depósito em conta"
      )
      
      @correntista.update!(saldo: @correntista.saldo + valor)
      
      render json: {
        mensagem: "Depósito realizado com sucesso",
        movimentacao: format_movimentacoes([@movimentacao]).first,
        saldo_atual: @correntista.saldo
      }
    end
  rescue => e
    render json: { error: "Erro ao realizar depósito: #{e.message}" }, status: :unprocessable_entity
  end
  
  private
  
  def format_movimentacoes(movimentacoes)
    movimentacoes.map do |mov|
      {
        movimentacao_id: mov.movimentacao_id,
        tipo_operacao: mov.tipo_operacao == 'C' ? 'Crédito' : 'Débito',
        correntista: {
          id: mov.correntista.correntista_id,
          nome: mov.correntista.nome_correntista
        },
        valor_operacao: mov.valor_operacao,
        data_operacao: mov.data_operacao.strftime('%d/%m/%Y %H:%M:%S'),
        descricao: mov.descricao,
        beneficiario: mov.beneficiario ? {
          id: mov.beneficiario.correntista_id,
          nome: mov.beneficiario.nome_correntista
        } : nil
      }
    end
  end
end