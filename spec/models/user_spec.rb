require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it 'is valid with a name, email, and password' do
      user = User.new(name: 'John Doe', email: 'john@example.com', password: 'securepassword')
      expect(user).to be_valid
    end

    it 'is invalid without a password' do
      user = User.new(name: 'John Doe', email: 'john@example.com')
      expect(user).not_to be_valid
    end

    it 'is invalid without an email' do
      user = User.new(name: 'John Doe', password: 'securepassword')
      expect(user).not_to be_valid
    end

    it 'is invalid with a duplicate email address' do
      User.create!(name: 'John Doe', email: 'john@example.com', password: 'securepassword')
      user = User.new(name: 'Jane Doe', email: 'john@example.com', password: 'anotherpassword')
      expect(user).not_to be_valid
    end
  end

  context 'authentication' do
    it 'authenticates with a valid password' do
      user = User.create!(name: 'John Doe', email: 'john@example.com', password: 'securepassword')
      expect(user.authenticate('securepassword')).to be_truthy
    end

    it 'does not authenticate with an invalid password' do
      user = User.create!(name: 'John Doe', email: 'john@example.com', password: 'securepassword')
      expect(user.authenticate('wrongpassword')).to be_falsey
    end
  end
end
