class MovimentacoesController < ApplicationController
  
  def index
    @movimentacoes = Movimentacao.includes(:correntista, :beneficiario)
                                 .order(:data_operacao)
    
    render json: format_movimentacoes(@movimentacoes)
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