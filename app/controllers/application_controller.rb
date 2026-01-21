# Controller base da aplicação - Todos os controllers herdam deste
# Implementa autenticação JWT obrigatória para todas as rotas
class ApplicationController < ActionController::API
  before_action :authenticate_jwt!

  private

  # Valida o token JWT enviado no header Authorization
  # Formato esperado: "Bearer <token>"
  def authenticate_jwt!
    auth_header = request.headers['Authorization']
    token = auth_header&.split(' ')&.last

    begin
      decoded = JWT.decode(token, jwt_secret, true, algorithm: 'HS256')
      @current_user = decoded.first
    rescue JWT::DecodeError
      render json: { error: 'Token inválido ou ausente' }, status: :unauthorized
    rescue JWT::ExpiredSignature
      render json: { error: 'Token expirado. Faça login novamente.' }, status: :unauthorized
    end
  end

  # Obtém a chave secreta do JWT das variáveis de ambiente
  def jwt_secret
    ENV.fetch('JWT_SECRET') { raise 'JWT_SECRET não configurado no arquivo .env' }
  end
end
