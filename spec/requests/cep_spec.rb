require 'rails_helper'

RSpec.describe CepController, type: :controller do
  describe 'GET #search' do
    let(:cep) { '01001-000' }
    let(:via_cep_instance) { instance_double(ViaCep) }
    let(:expected_result) do
      {
        cep: '01001-000',
        logradouro: 'Praça da Sé',
        complemento: 'lado ímpar',
        bairro: 'Sé',
        localidade: 'São Paulo',
        uf: 'SP'
      }.to_json
    end

    before do
      allow(ViaCep).to receive(:new).and_return(via_cep_instance)
      allow(via_cep_instance).to receive(:search).with(cep).and_return(JSON.parse(expected_result))
    end

    it 'calls ViaCep with the provided cep' do
      get :search, params: { cep: cep }

      expect(via_cep_instance).to have_received(:search).with(cep)
    end

    it 'returns the expected json result' do
      get :search, params: { cep: cep }

      expect(response.body).to eq(expected_result)
    end
  end
end
