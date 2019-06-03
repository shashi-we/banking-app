class NotificationMailer < ApplicationMailer

  def send_welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome!')
  end

  def send_credit_transaction_email(transaction)
    transaction_email(transaction)
  end

  def send_debit_transaction_email(transaction)
    transaction_email(transaction)
  end

  def transaction_email(transaction)
    @transaction = transaction
    @user = @transaction.bank_account.user
    mail(to: @user.email, subject: 'Transaction Alert!')
  end

end
