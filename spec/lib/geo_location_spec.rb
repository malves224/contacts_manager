require 'rails_helper'
require 'webmock/rspec'

RSpec.describe GeoLocation, type: :lib do
  before do
    stub_request(:get, 'https://nominatim.openstreetmap.org/search?q=Rua+Baleia+27,+Bairro+Conj+Hab+Sta+Etelvina,+Sao+Paulo,+SP&format=json&limit=1')
      .to_return(status: 200, body: '[{"lat": "-23.550520", "lon": "-46.633308", "display_name": "Rua Baleia, 27, Bairro Conj. Hab. Sta. Etelvina, São Paulo, SP, Brasil"}]', headers: { 'Content-Type' => 'application/json' })
  end

  describe '#search' do
    it 'returns geolocation data for a given address' do
      geo_location = GeoLocation.new
      result = geo_location.search('Rua Baleia 27, Bairro Conj Hab Sta Etelvina, Sao Paulo, SP')

      expect(result).to be_an(Array)
      expect(result.size).to eq(1)
      expect(result.first['lat']).to eq('-23.550520')
      expect(result.first['lon']).to eq('-46.633308')
    end

    it 'returns nil if the response is not successful' do
      stub_request(:get, 'https://nominatim.openstreetmap.org/search?q=Rua+Baleia+27,+Bairro+Conj+Hab+Sta+Etelvina,+Sao+Paulo,+SP&format=json&limit=1')
        .to_return(status: 500, body: '', headers: { 'Content-Type' => 'application/json' })

      geo_location = GeoLocation.new
      result = geo_location.search('Rua Baleia 27, Bairro Conj Hab Sta Etelvina, Sao Paulo, SP')

      expect(result).to be_nil
    end
  end
end
