# Controller de autenticação - Gerencia login e geração de tokens JWT
class AuthController < ApplicationController
  # Pula autenticação para a rota de login (senão não conseguiria logar!)
  skip_before_action :authenticate_jwt!, only: [:login]
  
  # POST /auth/login
  # Autentica o usuário e retorna um token JWT
  def login
    if valid_password?
      token = generate_jwt_token
      
      render json: { 
        token: token,
        expires_at: 24.hours.from_now.iso8601,
        message: 'Token gerado com sucesso'
      }
    else
      render json: { error: 'Credenciais inválidas' }, status: :unauthorized
    end
  end

  private

  # Verifica se a senha está correta
  def valid_password?
    params[:password].present? && params[:password] == ENV['ADMIN_PASSWORD']
  end

  # Gera um token JWT válido por 24 horas
  def generate_jwt_token
    payload = {
      authorized: true,
      iat: Time.current.to_i,          # Issued at (quando foi emitido)
      exp: 24.hours.from_now.to_i      # Expiration (quando expira)
    }
    
    JWT.encode(payload, jwt_secret, 'HS256')
  end

  # Obtém a chave secreta do JWT das variáveis de ambiente
  def jwt_secret
    ENV.fetch('JWT_SECRET') { raise 'JWT_SECRET não configurado no arquivo .env' }
  end
end
  