# -*- coding: utf-8 -*-
class Admin::DonateMessagesController < AdminController
  inherit_resources

  def index
    @donate_messages = DonateMessage.order('id DESC').page(params[:page]).per(20)
  end

end
