class Address < ApplicationRecord
  belongs_to :contact
  validates :street, :city, :state, :postal_code, presence: true
end
