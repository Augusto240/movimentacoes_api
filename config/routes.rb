Rails.application.routes.draw do
  # 🔌 WebSocket - Action Cable
  mount ActionCable.server => '/cable'

  # 🔐 Autenticação
  post '/auth/login', to: 'auth#login'

  # 🧍‍♂️ Correntistas
  resources :correntistas, only: [:index, :show]

  # 💸 Movimentações
  resources :movimentacoes, only: [:index]
  root 'movimentacoes#index'
  
  # Operações bancárias
  get '/extrato/:correntista_id', to: 'movimentacoes#extrato'
  post '/pagar', to: 'movimentacoes#pagar'
  post '/transferir', to: 'movimentacoes#transferir'
  post '/sacar', to: 'movimentacoes#sacar'
  post '/depositar', to: 'movimentacoes#depositar'
end
