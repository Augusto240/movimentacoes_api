class ApplicationController < ActionController::API
    before_action :authenticate_jwt!
  
    private
  
    def authenticate_jwt!
      token = extract_token_from_header
      
      unless token
        render json: { error: 'Token não fornecido' }, status: :unauthorized
        return
      end
  
      begin
        decoded_token = JWT.decode(token, jwt_secret, true, { algorithm: 'HS256' })
        payload = decoded_token.first
        
        unless payload['authorized']
          render json: { error: 'Token inválido' }, status: :unauthorized
          return
        end

        @current_token_payload = payload
        
      rescue JWT::ExpiredSignature
        render json: { error: 'Token expirado' }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { error: 'Token malformado' }, status: :unauthorized
      end
    end
  
    def extract_token_from_header
      header = request.headers['Authorization']
      return nil unless header&.start_with?('Bearer ')
      
      header.split(' ').last
    end
  
    def jwt_secret
      ENV.fetch('JWT_SECRET') { raise 'JWT_SECRET não configurado' }
    end
  end
  