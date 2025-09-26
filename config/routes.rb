Rails.application.routes.draw do
  resources :movimentacoes, only: [:index]
  
  root 'movimentacoes#index'
  
  # root "posts#index"
end