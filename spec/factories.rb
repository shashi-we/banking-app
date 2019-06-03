FactoryBot.define do
  
  factory :user do
    name { 'Joe Doe' }
    sequence(:email) { |n| "joe#{n}@gmail.com" }
    password { 'blah' }
    address { 'Park street, My city' }
  end

end
