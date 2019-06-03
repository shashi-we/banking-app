class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :bank_account, dependent: :destroy

  validates :name, presence: :true

  after_create :create_bank_account, :send_welcome_email

  delegate :account_number, to: :bank_account, allow_nil: false
  delegate :balance_amount, to: :bank_account, allow_nil: false

  private

    def create_bank_account
      self.bank_account = BankAccount.create!(
        account_number: rand.to_s[2..9],
        balance_amount: 0.0,
        user_id: self.id
      )
      self.save!
    end

    def send_welcome_email
      NotificationMailer.send_welcome_email(self).deliver_now
    end
end
