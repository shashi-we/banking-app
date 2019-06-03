class CreateBankTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_transactions do |t|
      t.references  :bank_account, foreign_key: true
      t.integer     :transaction_type
      t.string      :description
      t.decimal     :transaction_amount
      t.decimal     :balance_amount
      t.datetime    :transaction_time

      t.timestamps
    end
  end
end
