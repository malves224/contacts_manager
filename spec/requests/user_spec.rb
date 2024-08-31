# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let!(:user) { create(:user, email: 'matheus@email.com', password: '123456') }

  describe 'POST /users' do
    it 'returns a 200 status code with user' do
      post '/users', params: { email: 'matheus1@email.com', password: '123456', name: 'Matheus' }
      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['name']).to eq('Matheus')
      expect(parsed_response['email']).to eq('matheus1@email.com')
      expect(parsed_response).to include('id')
    end

    context 'with existing email' do
      it 'returns a 422 status code with errors' do
        post '/users', params: { email: 'matheus@email.com', password: '123456', name: 'Matheus' }
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to eq(['Email Já existe um usuário com esse email'])
      end
    end
  end

  describe 'DELETE /users/self_destroy' do
    let(:auth) { { 'Authorization' => "Bearer #{JsonWebToken.encode({ id: user.id })}" } }
    it 'returns a 204 status code' do
      delete '/users/self_destroy', headers: auth
      expect(response).to have_http_status(:no_content)
    end
  end
end
