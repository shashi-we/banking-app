class BankTransactionsController < ApplicationController
  access customer: [:new, :create]

  def new
    @bank_transaction = current_user.bank_transactions.build
    @bank_transaction.transaction_type = params[:transaction_type]
  end

  def create
    @bank_transaction = BankTransaction.new(bank_transaction_params)
    @bank_transaction.bank_account_id = current_user.bank_account.id
    @bank_transaction.transaction_time = Time.now

    if @bank_transaction.save
      redirect_to dashboard_path, flash: { success: "Amount deposited successfully" }
    else
      render :new
    end
  end

  private

  def bank_transaction_params
    params.require(:bank_transaction).permit(:transaction_type, :transaction_amount, :description)
  end
end
