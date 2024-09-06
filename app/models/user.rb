class User < ApplicationRecord
  has_secure_password
  has_many :contacts, dependent: :destroy

  validates :email, presence: true, uniqueness: { message: 'Já existe um usuário com esse email' }

  def reset_password
    password = SecureRandom.hex(6)
    PasswordMailer.new.reset_password(self, password).deliver
  end
end
