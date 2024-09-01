require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do 
    it { should belong_to(:user) }
  end
  describe 'validations' do
    it 'is invalid with an incorrect CPF' do
      contact = Contact.new(doc: '12345678901', user_id: user.id)
      expect(contact).not_to be_valid
      expect(contact.errors[:doc]).to include('não é válido')
    end

    it 'is valid with a correct CPF' do
      contact = Contact.new(doc: '03863142098', user_id: user.id)
      expect(contact).to be_valid
    end
  end
end
