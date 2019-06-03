class BankTransaction < ApplicationRecord
  include Transactionable

  belongs_to :bank_account

  enum transaction_type: [:credit, :debit]
  
end
