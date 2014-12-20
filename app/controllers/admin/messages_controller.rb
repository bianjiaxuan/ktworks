# -*- coding: utf-8 -*-
class Admin::MessagesController < AdminController
  inherit_resources

  def index
    @messages = Message.order('id DESC').page(params[:page]).per(20)
  end

end
