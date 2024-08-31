class ApplicationController < ActionController::API
  rescue_from JWT::DecodeError, with: ->(e) { render json: { errors: e.message }, status: :unauthorized }
  rescue_from ActiveRecord::RecordNotFound, with: ->(e) { render json: { errors: e.message }, status: :not_found }

  private

  def require_login
    token = request.headers['Authorization']&.split(' ')&.last

    if token.present?
      begin
        decoded_token = JsonWebToken.decode(token)
        @user = User.find(decoded_token['id'])
      end
    else
      render json: { errors: 'Token is missing' }, status: :unauthorized
    end
  end
end
