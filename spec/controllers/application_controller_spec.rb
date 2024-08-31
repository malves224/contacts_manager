# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    before_action :require_login

    def index
      render json: { message: 'Success' }
    end
  end

  let(:user) { create(:user) }
  let(:valid_token) { JsonWebToken.encode({ id: user.id }) }
  let(:expired_token) { JsonWebToken.encode({ id: user.id }, 1.hour.ago) }
  let(:invalid_token) { 'invalid_token' }

  describe 'JWT token handling' do
    context 'when token is valid' do
      it 'allows access' do
        request.headers['Authorization'] = "Bearer #{valid_token}"
        get :index
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ message: 'Success' }.to_json)
      end
    end

    context 'when token is missing' do
      it 'returns unauthorized' do
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq({ errors: 'Token is missing' }.to_json)
      end
    end

    context 'when token is expired' do
      it 'returns unauthorized with expiration message' do
        request.headers['Authorization'] = "Bearer #{expired_token}"
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq({ errors: 'Signature has expired' }.to_json)
      end
    end

    context 'when token is invalid' do
      it 'returns unauthorized with decode error message' do
        request.headers['Authorization'] = "Bearer #{invalid_token}"
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq({ errors: 'Not enough or too many segments' }.to_json)
      end
    end
  end

  describe 'handling RecordNotFound' do
    it 'returns not found when record is missing' do
      allow(User).to receive(:find).and_raise(ActiveRecord::RecordNotFound.new("Couldn't find User"))
      request.headers['Authorization'] = "Bearer #{valid_token}"
      get :index
      expect(response).to have_http_status(:not_found)
      expect(response.body).to eq({ errors: "Couldn't find User" }.to_json)
    end
  end
end
