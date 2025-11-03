class ApplicationController < ActionController::API
  before_action :authenticate_jwt!

  private

  def authenticate_jwt!
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last if auth_header

    begin
      decoded = JWT.decode(token, jwt_secret, true, algorithm: 'HS256')
      @current_user = decoded.first
    rescue JWT::DecodeError
      render json: { error: 'Token inválido ou ausente' }, status: :unauthorized
    rescue JWT::ExpiredSignature
      render json: { error: 'Token expirado' }, status: :unauthorized
    end
  end

  def jwt_secret
    ENV.fetch('JWT_SECRET') { raise 'JWT_SECRET não configurado' }
  end
end
