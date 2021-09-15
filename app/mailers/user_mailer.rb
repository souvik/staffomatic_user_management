class UserMailer < ApplicationMailer
  def status_change_notifier
    @user = params[:user]
    mail(to: @user.email, subject: "Your profile status has been changed.")
  end
end
