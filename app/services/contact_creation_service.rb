class ContactCreationService
  def initialize(contact_params, user)
    @contact_params = contact_params
    @user = user
    @contact = Contact.new(contact_params.merge(user_id: user.id))
  end

  def call
    search_geo_location
    save_contact
  end

  private

  attr_reader :contact, :contact_params, :user

  def search_geo_location
    geo_location = GeoLocation.new.search(contact.address.to_query)
    if geo_location.present?
      contact.address.latitude = geo_location[0]['lat']
      contact.address.longitude = geo_location[0]['lon']
    end
  end

  def save_contact
    contact.save
    contact
  end
end
