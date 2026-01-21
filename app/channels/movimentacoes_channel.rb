# Canal para notificações de movimentações bancárias em tempo real
# Este canal permite que o front-end receba atualizações instantâneas
# quando qualquer operação bancária é realizada
class MovimentacoesChannel < ApplicationCable::Channel
  # Quando o cliente se inscreve no canal
  def subscribed
    # Stream para todos os clientes conectados (broadcast geral)
    stream_from "movimentacoes_channel"
    
    logger.info "Cliente inscrito no canal de movimentações"
  end

  # Quando o cliente cancela a inscrição
  def unsubscribed
    logger.info "Cliente saiu do canal de movimentações"
  end

  # Método para inscrever em um correntista específico
  def subscribe_to_correntista(data)
    correntista_id = data['correntista_id']
    stream_from "movimentacoes_correntista_#{correntista_id}"
    
    logger.info "Cliente inscrito nas movimentações do correntista #{correntista_id}"
  end
end
