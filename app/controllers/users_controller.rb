class UsersController < ApplicationController
  before_action :require_login, only: %i[self_destroy]
  def create
    user = User.new(params_permit)
    if user.save
      render status: :ok, json: user.as_json(only: %i[id name email])
    else
      render status: :unprocessable_entity, json: { errors: user.errors.full_messages }
    end
  end

  def self_destroy
    render status: 204 if @user.destroy
  end

  private

  def params_permit
    params.permit(:id, :email, :password, :name)
  end
end
