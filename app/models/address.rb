class Address < ApplicationRecord
  belongs_to :contact
  validates :street, :city, :state, :postal_code, presence: true

  def to_query
    I18n.transliterate("#{street}+#{number}+#{city}+#{state}".gsub(' ', '+'))
  end
end
