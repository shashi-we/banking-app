Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  root 'home#index'
  get '/dashboard', to: 'home#dashboard'
  resources :bank_transactions, only: [:create]
  get '/transactions/:transaction_type', to: 'bank_transactions#new', as: 'new_transaction'

  # admin paths
  get '/admin/dashboard', to: 'admin#dashboard'
  get '/admin/customer/:id', to: 'admin#customer_detail', as: 'admin_customer_detail'
  get '/admin/transaction-histories', to: 'admin#transaction_histories', as: 'transaction_histories'
  post '/admin/transaction-report', to: 'admin#transaction_report', as: 'transaction_report'
  
end
