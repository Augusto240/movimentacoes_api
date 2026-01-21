# Controller para gerenciar os correntistas (contas bancárias)
class CorrentistasController < ApplicationController
  # GET /correntistas
  # Lista todos os correntistas com seus saldos
  def index
    correntistas = Correntista.select(:correntista_id, :nome_correntista, :saldo)
                              .order(:nome_correntista)
    render json: correntistas.map { |c| format_correntista(c) }
  end

  # GET /correntistas/:id
  # Mostra detalhes de um correntista específico
  def show
    correntista = Correntista.find_by(correntista_id: params[:id])
    
    if correntista
      render json: format_correntista(correntista)
    else
      render json: { error: 'Correntista não encontrado' }, status: :not_found
    end
  end

  private

  # Formata os dados do correntista para retorno JSON
  def format_correntista(correntista)
    {
      correntista_id: correntista.correntista_id,
      nome_correntista: correntista.nome_correntista,
      saldo: correntista.saldo.to_f
    }
  end
end
