class User < ApplicationRecord
  has_secure_password

  # Adicione validações adicionais se necessário
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
