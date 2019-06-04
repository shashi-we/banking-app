class User < ApplicationRecord
  petergate(roles: [:admin, :customer], multiple: false)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :bank_account, dependent: :destroy

  validates :name, presence: :true

  before_create :set_role
  after_create :create_bank_account, :send_welcome_email, if: :customer?

  delegate :account_number, to: :bank_account, allow_nil: false
  delegate :balance_amount, to: :bank_account, allow_nil: false
  delegate :bank_transactions, to: :bank_account

  def customer?
    self.has_roles?(:customer)
  end

  private

    def set_role
      self.roles = 'customer' unless self.has_roles?(:admin)
    end

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
