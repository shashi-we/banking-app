Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  root 'home#index'
  get '/dashboard', to: 'home#dashboard'
  resources :bank_transactions, only: [:create]
  get '/transactions/:transaction_type', to: 'bank_transactions#new', as: 'new_transaction'
end
