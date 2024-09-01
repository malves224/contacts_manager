class PasswordMailer < ApplicationMailer
  default from: 'no-reply@vollsolutions.com.br'

  def reset_password(user, new_password)
    @new_password = new_password
    @user = user
    mail(to: @user.email, subject: 'Resetar sua senha') do |format|
      format.html { render 'password_mailer/reset_password', layout: 'reset_password' }
    end
  end
end
