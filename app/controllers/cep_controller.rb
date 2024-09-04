class CepController < ApplicationController
  def search
    result = ViaCep.new.search(params_permit[:cep])
    render json: result
  end

  def params_permit
    params.permit(:cep)
  end
end
