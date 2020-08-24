class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t(".mail_active")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t(".mail_reset_pass")
  end
end
