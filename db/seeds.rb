User.create!(
  name: "Admin",
  email: "admin@test.com", 
  password: "1234", 
  password_confirmation: "1234",
  roles: "admin"
)
puts '1 admin is created'

5.times do |i|
  User.create!(
    name: "User #{i+1}",
    email: "user#{i+1}@test.com", 
    password: "password", 
    password_confirmation: "password",
    roles: "customer", 
    address: "User #{i+1} address"
  )
end
puts '5 customers are created'

2.times do |i|
  BankAccount.first.bank_transactions.create!(
    transaction_type: "credit",
    description: "adding money",
    transaction_amount: 100,
    transaction_time: Time.now
  )
  BankAccount.find(i+3).bank_transactions.create!(
    transaction_type: "credit",
    description: "first deposit",
    transaction_amount: 90,
    transaction_time: Time.now
  )
  BankAccount.last.bank_transactions.create!(
    transaction_type: "credit",
    description: "for saving",
    transaction_amount: 120,
    transaction_time: Time.now
  )
end
puts '6 credit transactions added'

3.times do |i|
  BankAccount.first.bank_transactions.create!(
    transaction_type: "debit",
    description: "emergency withdrawl",
    transaction_amount: 35,
    transaction_time: Time.now
  )
  BankAccount.last.bank_transactions.create!(
    transaction_type: "debit",
    description: "withdrawing for shopping",
    transaction_amount: 40,
    transaction_time: Time.now
  )
end
puts '6 debit transactions added'
