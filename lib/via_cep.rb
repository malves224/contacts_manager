class ViaCep
  def initialize
    @client = Faraday.new(url: 'https://viacep.com.br/ws/')
  end

  def search(cep)
    response = @client.get("#{cep}/json") do |req|
      req.headers['Content-Type'] = 'application/json'
    end
    JSON.parse(response.body)
  end
end
