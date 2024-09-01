class Contact < ApplicationRecord
  belongs_to :user

  validate :cpf_must_be_valid

  private

  def cpf_must_be_valid
    return if doc.blank?

    clean_cpf = doc.gsub(/[^0-9]/, '')
    unless CPF.valid?(clean_cpf)
      errors.add(:doc, 'não é válido')
    end
  end
end
