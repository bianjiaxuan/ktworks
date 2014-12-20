# -*- coding: utf-8 -*-
class Admin::UsersController::UserMailer < ActionMailer::Base
  default from: "notification@tempot.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.usermailer.send_generated_password.subject
  #
  def send_generated_password user
    @user = user
    mail to: user.email, subject: '欢迎来到KickTempo'
  end
end
