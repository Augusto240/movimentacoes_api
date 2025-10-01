Rails.application.routes.draw do
  resources :movimentacoes, only: [:index]
  
  root 'movimentacoes#index'
  
  get '/extrato/:correntista_id', to: 'movimentacoes#extrato'

  post '/pagar', to: 'movimentacoes#pagar'

  post 'transferir', to: 'movimentacoes#transferir'

  post 'sacar', to: 'movimentacoes#sacar'

  post 'depositar', to: 'movimentacoes#depositar'

end