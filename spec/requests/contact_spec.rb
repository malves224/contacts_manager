require 'rails_helper'

RSpec.describe ContactsController, type: :request do
  let!(:user) { create(:user) }
  let(:valid_token) { JsonWebToken.encode({ id: user.id }) }
  let(:headers) { { 'Authorization' => "Bearer #{valid_token}" } }
  let(:valid_params) do
    {
      contact: {
        doc: '70171456157',
        phone: '123456789',
        name: 'John Doe',
        address_attributes:
          {
            street: '123 Main St',
            city: 'Anytown',
            state: 'Anystate',
            postal_code: '12345'
          }
      }
    }
  end

  let(:invalid_params) do
    {
      contact: {
        doc: '',
        phone: '123456789',
        name: 'John Doe',
        address_attributes:
          {
            street: '123 Main St',
            city: 'Anytown',
            state: 'Anystate',
            postal_code: '12345'
          }
      }
    }
  end

  before do
    allow(controller).to receive(:require_login).and_return(true)
    allow(controller).to receive(:@user).and_return(user)
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new contact' do
        post '/contacts', params: valid_params, headers: headers

        expect(response).to have_http_status(:created)
        expect(Contact.count).to eq(1)
        expect(JSON.parse(response.body)['doc']).to eq(valid_params[:contact][:doc])
      end
    end

    context 'with invalid params' do
      it 'does not create a new contact' do
        expect do
          post '/contacts', params: invalid_params, headers: headers
        end.not_to change(Contact, :count)
      end

      it 'returns errors as JSON with status :unprocessable_entity' do
        post '/contacts', params: invalid_params, headers: headers
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include("Doc can't be blank")
      end
    end
  end
end
