require 'rails_helper'

RSpec.describe User, type: :model do

  
  context 'new user' do
    before(:all) do
      @user = create(:user)
    end

    it 'is valid with valid attributes' do
      expect(@user).to be_valid
    end
    
    it 'has a unique email' do
      user2 = build(:user, name: 'Bob', email: @user.email)
      expect(user2).not_to be_valid
    end
    
    it 'is not valid without a password' do 
      user2 = build(:user, password: nil)
      expect(user2).not_to be_valid
    end
    
    it 'is not valid without an email' do
      user2 = build(:user, email: nil)
      expect(user2).not_to be_valid
    end

    it 'is not valid without a name' do
      user2 = build(:user, name: nil, email: 'bob@gmail.com', password: 'abcd')
      expect(user2).not_to be_valid
    end

    it 'creates bank account' do
      association = described_class.reflect_on_association(:bank_account)
      expect(association.macro).to eq(:has_one)
    end

    it 'sends an email after creating user successfully'
  end

end
