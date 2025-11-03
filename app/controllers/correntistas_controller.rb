class CorrentistasController < ApplicationController
  before_action :authenticate_jwt!

  def index
    correntistas = Correntista.select(:correntista_id, :nome_correntista, :saldo)
    render json: correntistas
  end

  def show
    correntista = Correntista.find_by(correntista_id: params[:id])
    if correntista
      render json: correntista
    else
      render json: { error: 'Correntista não encontrado' }, status: :not_found
    end
  end
end
