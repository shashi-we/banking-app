class BankAccount < ApplicationRecord
  belongs_to :user
  has_many :bank_transactions, dependent: :destroy
end
