class GeoLocation
  def initialize
    @client = Faraday.new(url: 'https://nominatim.openstreetmap.org/')
  end

  def search(address)
    response = @client.get("search?q=#{address}&format=json&limit=1")
    JSON.parse(response.body) if response.success?
  end
end
