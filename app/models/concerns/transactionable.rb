module Transactionable
  extend ActiveSupport::Concern

  included do
    validates :transaction_amount, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than: 0 }
    validate :check_available_balance, if: :debit?, on: :create
    after_create :update_balance, :send_transactional_email
  end

  def check_available_balance
    errors.add(:transaction_amount, "insufficient balance in account") if transaction_amount > bank_account.balance_amount
  end

  def update_balance
    update_bank_account_balance
    update_transaction_balance
  end

  def update_bank_account_balance
    if self.credit?
      self.bank_account.balance_amount = self.bank_account.balance_amount + self.transaction_amount
    else
      self.bank_account.balance_amount = self.bank_account.balance_amount - self.transaction_amount
    end
    self.bank_account.save!
  end

  def update_transaction_balance
    self.balance_amount = bank_account.balance_amount
    self.save!
  end

  def send_transactional_email
    if self.credit?
      NotificationMailer.send_credit_transaction_email(self).deliver_now
    else
      NotificationMailer.send_debit_transaction_email(self).deliver_now
    end
  end
end
