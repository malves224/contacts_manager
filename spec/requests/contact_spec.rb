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

  describe "GET #search" do
    let!(:contact1) { create(:contact, doc: '23162834031', name: 'John Doe', user: user) }
    let!(:contact2) { create(:contact, doc: '59565336094', name: 'Jane Doe', user: user) }
    let!(:contact3) { create(:contact, doc: '32146197056', name: 'Alice Smith', user: user) }

    context 'when searching by doc' do
      it 'returns contacts matching the doc' do
        get '/contacts/search', params: { value: '23162834031' }, headers: headers
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response.size).to eq(1)
        expect(json_response.first['id']).to eq(contact1.id)
      end
    end

    context 'when searching by name' do
      it 'returns contacts matching the name' do
        get '/contacts/search', params: { value: 'John' }, headers: headers
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response.size).to eq(1)
        expect(json_response.first['id']).to eq(contact1.id)
      end
    end

    context 'when searching with an empty value' do
      it 'returns all contacts' do
        get '/contacts/search', params: { value: '' }, headers: headers
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response.size).to eq(3)
      end
    end
  end
end
