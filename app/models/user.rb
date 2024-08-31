class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: { message: 'Já existe um usuário com esse email' }
end
