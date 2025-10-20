Rails.application.routes.draw do
  post '/auth/login', to: 'auth#login'

  resources :movimentacoes, only: [:index]
  root 'movimentacoes#index'
  
  get '/extrato/:correntista_id', to: 'movimentacoes#extrato'
  post '/pagar', to: 'movimentacoes#pagar'
  post '/transferir', to: 'movimentacoes#transferir'
  post '/sacar', to: 'movimentacoes#sacar'
  post '/depositar', to: 'movimentacoes#depositar'
end
