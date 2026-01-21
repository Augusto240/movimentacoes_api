# Base class para todos os canais WebSocket
# Os channels permitem comunicação em tempo real entre servidor e cliente
class ApplicationCable::Connection < ActionCable::Connection::Base
  # Identificador único da conexão (poderia ser user_id se tivéssemos login por usuário)
  identified_by :connection_id

  def connect
    # Gera um ID único para cada conexão
    self.connection_id = SecureRandom.uuid
    logger.info "WebSocket conectado: #{connection_id}"
  end

  def disconnect
    logger.info "WebSocket desconectado: #{connection_id}"
  end
end
