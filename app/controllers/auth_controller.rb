class AuthController < ActionController::API
    def login
      if params[:password] == ENV['ADMIN_PASSWORD']
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
  
    def generate_jwt_token
      payload = {
        authorized: true,
        iat: Time.now.to_i,          
        exp: 24.hours.from_now.to_i   
      }
      
      JWT.encode(payload, jwt_secret, 'HS256')
    end
  
    def jwt_secret
      ENV.fetch('JWT_SECRET') { raise 'JWT_SECRET não configurado' }
    end
  end
  