require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it 'is invalid with an incorrect CPF' do
      contact = build(:contact, doc: '12345678901', user_id: user.id)
      expect(contact).not_to be_valid
      expect(contact.errors[:doc]).to include('não é válido')
    end

    it 'is valid with a correct CPF' do
      contact = build(:contact, doc: '03863142098', user_id: user.id)
      expect(contact).to be_valid
    end

    it 'is invalid with doc already taken' do
      create(:contact, doc: '03863142098', user_id: user.id)
      contact = build(:contact, doc: '03863142098', user_id: user.id)
      expect(contact).not_to be_valid
      expect(contact.errors[:doc]).to include('Já existe um usuário com esse cpf')
    end
  end
end
