module BankTransactionsHelper
  def transaction_title(transaction)
    if transaction.credit?
      "Deposit Money"
    else
      "Withdraw Money"
    end
  end
end
