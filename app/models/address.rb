class Address < ApplicationRecord
  belongs_to :contact
  validates :street, :city, :state, :postal_code, presence: true

  def to_query
    "#{street}+#{number}+#{city}+#{state}"
  end
end
