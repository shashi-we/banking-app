require 'rails_helper'

RSpec.describe BankTransaction, type: :model do
  let(:user) { create(:user) }
  let(:account) { user.bank_account }
  
  context 'validations' do
    describe 'with invalid amount' do
      let(:zero_amt_transaction) { described_class.create(bank_account_id: account.id, transaction_amount: 0.0) }
      let(:negative_amt_transaction) { described_class.create(bank_account_id: account.id, transaction_amount: -7.5) }
      let(:bad_amt_transaction) { described_class.create(bank_account_id: account.id, transaction_amount: 'abc#!@') }

      it 'cancels transaction for amount less than zero' do
        expect(zero_amt_transaction).not_to be_valid
        expect(negative_amt_transaction).not_to be_valid
      end

      it 'cancels transaction for malformed amount' do
        expect(bad_amt_transaction).not_to be_valid
      end

      it 'returns error message for cancelled transaction' do
        expect(zero_amt_transaction.errors.messages[:transaction_amount].last).to eq('must be greater than 0')
        expect(negative_amt_transaction.errors.messages[:transaction_amount].last).to eq('must be greater than 0')
      end
    end
  end

  context 'deposit' do
    describe 'with valid amount' do
      let(:credit_transaction) { described_class.create(bank_account_id: account.id, transaction_amount: 5.0, transaction_type: 'credit', description: 'deposit cash', transaction_time: Time.now) }

      it "create :credit transaction for given amount" do
        expect(credit_transaction).to be_valid
      end

      it "update balance_amount in user's bank_account" do
        before_transaction_amount = account.balance_amount
        after_transaction_amount = credit_transaction.balance_amount
        expect(after_transaction_amount - before_transaction_amount).to eq(credit_transaction.transaction_amount)
      end

      it 'sends transactional email for deposit'
    end
  end

  context 'withdraw' do
    describe 'with valid amount' do
      let(:credit_transaction) { described_class.create(bank_account_id: account.id, transaction_amount: 10.0, transaction_type: 'credit', description: 'deposit cash', transaction_time: Time.now) }
      let(:debit_transaction) { described_class.create(bank_account_id: account.id, transaction_amount: 5.0, transaction_type: 'debit', description: 'withdraw cash', transaction_time: Time.now) }
      let(:overlimit_debit_transaction) { described_class.create(bank_account_id: account.id, transaction_amount: 5.0, transaction_type: 'debit', description: 'withdraw cash', transaction_time: Time.now) }

      it 'cancels transaction for amount greater than available balance' do
        expect(overlimit_debit_transaction).not_to be_valid
        expect(overlimit_debit_transaction.errors.messages[:transaction_amount].last).to eq('insufficient balance in account')
      end

      it 'create :debit transaction for given amount' do
        credit_transaction
        expect(debit_transaction).to be_valid
      end
      
      it "update balance_amount in user's bank_account" do
        before_transaction_amount = credit_transaction.balance_amount
        after_transaction_amount = debit_transaction.balance_amount
        expect(before_transaction_amount - after_transaction_amount).to eq(debit_transaction.transaction_amount)
      end

      it 'sends transactional email for withdraw'
    end
  end
end
