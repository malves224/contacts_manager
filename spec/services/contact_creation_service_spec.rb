require 'rails_helper'

RSpec.describe ContactCreationService, type: :service do
  let(:user) { create(:user) }
  let(:contact_params) do
    {
      doc: '51831295091',
      phone: '1234567890',
      name: 'John Doe',
      address_attributes: {
        street: 'Rua Baleia',
        number: '27',
        city: 'São paulo',
        state: 'SP',
        postal_code: '01310-000'
      }
    }
  end

  let(:geo_location) { instance_double('GeoLocation') }

  before do
    allow(GeoLocation).to receive(:new).and_return(geo_location)
    allow(geo_location).to receive(:search).and_return([{ 'lat' => '-23.550520', 'lon' => '-46.633308' }])
  end

  it 'creates a contact with geolocation data' do
    service = ContactCreationService.new(contact_params, user)
    contact = service.call
    expect(contact).to be_persisted
    expect(contact.address.latitude).to eq('-23.550520')
    expect(contact.address.longitude).to eq('-46.633308')
  end

  it 'saves the contact correctly' do
    service = ContactCreationService.new(contact_params, user)
    contact = service.call

    expect(contact).to be_persisted
    expect(contact.doc).to eq('51831295091')
    expect(contact.phone).to eq('1234567890')
    expect(contact.name).to eq('John Doe')
  end
end
