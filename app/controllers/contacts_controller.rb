class ContactsController < ApplicationController
  before_action :require_login
  def search
    render json: Contact.search(search_params).as_json(include: :address)
  end

  def create
    contact = ContactCreationService.new(contact_params, @user).call
    if contact.errors.present?
      render json: { errors: contact.errors.full_messages }, status: :unprocessable_entity
    else
      render json: contact, status: :created
    end
  end

  def destroy
    contact = Contact.find(params[:id])
    if contact.destroy
      render json: { message: 'Contato deletado com sucesso' }, status: :ok
    else
      render status: :not_found
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:doc, :phone, :name,
      address_attributes: [:id, :street, :city, :state, :postal_code, :latitude, :longitude, :complement, :number, :district])
  end

  def search_params
    params.permit(:order, :value)
  end
end
