require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'associations' do 
    it { should belong_to(:contact) }
  end
end
