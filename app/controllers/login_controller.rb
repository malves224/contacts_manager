class LoginController < ApplicationController
  def login
    user = User.find_by_email(params_permit[:email])
    if user&.authenticate(params_permit[:password])
      payload = { id: user.id, email: user.email }
      return render status: :ok, json: { id: user.id, token: JsonWebToken.encode(payload) }
    end
    render status: :unauthorized, json: { errors: ['Login ou senha inválidos'] }
  end

  def forgot_password
    user = User.find_by_email(params_permit[:email])
    return render status: :unprocessable_entity, json: { errors: ['Email não cadastrado']} if user.nil?

    user.reset_password
    render status: :ok
  end
  
  private

  def params_permit
    params.permit(:email, :password)
  end
end
