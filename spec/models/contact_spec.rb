require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_one(:address) }
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

  describe '.search' do
    let(:user) { create(:user) }
    let(:contact) { create(:contact, name: 'john doe', user: user) }
    let(:contact2) { create(:contact, doc: '23162834031', user: user) }
    let(:params) { { value: 'john' } }

    it 'returns contacts with name containing the value' do
      expect(Contact.search(params)).to include(contact)
    end

    it 'returns contacts with doc containing the value' do
      expect(Contact.search({ value: '23162834031' })).to include(contact2)
    end

    it 'return all contacts' do
      expect(Contact.search({ value: '', order: '' })).to include(contact, contact2)
    end
  end
end
