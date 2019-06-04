class AdminController < ApplicationController
  access admin: [:dashboard, :customer_detail]

  def dashboard
    @customers = User.role_customers
  end

  def customer_detail
    @customer = User.find(params[:id])
    @transactions = @customer.bank_transactions
  end

  def transaction_histories
  end
end
  