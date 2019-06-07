class AdminController < ApplicationController
  before_action :set_customers, except: [:customer_detail]
  access admin: [:dashboard, :customer_detail, :transaction_histories, :transaction_report]

  def dashboard
  end

  def customer_detail
    @customer = User.find(params[:id])
    @transactions = @customer.bank_transactions
  end

  def transaction_histories
  end

  def transaction_report
    account_ids = params[:account_ids].map(&:to_i) unless params[:account_ids].nil?
    @transactions = BankTransaction.where("date(transaction_time) >= ? AND date(transaction_time) <= ?", params[:start_date], params[:end_date]).where(bank_account_id: account_ids).includes(:bank_account)

    @account_transactions = @transactions.group_by { |t| t.bank_account.account_number }
    
    if @transactions.empty?
      redirect_to transaction_histories_path, notice: 'No transactions found.'
    end

    respond_to do |format|
      format.xls { headers["Content-Disposition"] = "attachment; filename=\"transaction-reports.xls\"" } 
      format.html
    end
  end

  private
  
  def set_customers
    @customers = User.role_customers.includes(:bank_account)
  end
end
  