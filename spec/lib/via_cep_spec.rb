require 'rails_helper'

RSpec.describe ViaCep do
  let(:cep) { '01001000' }
  let(:valid_response) do
    {
      'cep' => '01001-000',
      'logradouro' => 'Praça da Sé',
      'complemento' => 'lado ímpar',
      'bairro' => 'Sé',
      'localidade' => 'São Paulo',
      'uf' => 'SP',
      'ibge' => '3550308',
      'gia' => '1004',
      'ddd' => '11',
      'siafi' => '7107'
    }.to_json
  end

  before do
    stub_request(:get, "https://viacep.com.br/ws/#{cep}/json")
      .with(headers: { 'Content-Type' => 'application/json' })
      .to_return(status: 200, body: valid_response, headers: {})
  end

  describe '#search' do
    it 'returns parsed JSON response for a valid CEP' do
      via_cep = ViaCep.new
      result = via_cep.search(cep)

      expect(result['cep']).to eq('01001-000')
      expect(result['logradouro']).to eq('Praça da Sé')
      expect(result['bairro']).to eq('Sé')
      expect(result['localidade']).to eq('São Paulo')
      expect(result['uf']).to eq('SP')
    end
  end
end
