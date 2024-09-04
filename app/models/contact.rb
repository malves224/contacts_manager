class Contact < ApplicationRecord
  belongs_to :user
  has_one :address, dependent: :destroy

  validates :phone, presence: true
  validates :doc, presence: true, uniqueness: { message: 'Já existe um usuário com esse cpf' }
  validate :cpf_must_be_valid

  accepts_nested_attributes_for :address, allow_destroy: true

  def cpf_must_be_valid
    return if doc.blank?

    clean_cpf = doc.gsub(/[^0-9]/, '')
    errors.add(:doc, 'não é válido') unless CPF.valid?(clean_cpf)
  end

  def self.search(params)
    query = Contact.all
    if params[:value].present?
      value = "%#{params[:value]}%"
      query = query.where('doc ILIKE ? OR name ILIKE ?', value, value)
    end
    query = query.order(created_at: params[:order]) if params[:order].present?
    query
  end
end
