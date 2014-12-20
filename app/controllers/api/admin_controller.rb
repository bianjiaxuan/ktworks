# -*- coding: utf-8 -*-
class Api::AdminController < Api::BaseController
  before_filter :authenticate!

  # 土豆授权信息
  # CODE = "8ab825345557af492947821bd2dfcc24"
  # APP_KEY = "651dd620b8363430"
  # APP_SECRET = "455b5daaa27197008d7961dc2baf0d13"
  # ACCESS_TOKEN = "JkoZZk55BTmyooNkm__ka55kJmTNZmJ5p_N5yy_BmT4Z_ZgZmp5BmN4gJ4NpB_J4gmmpp5gmoNZoZZN"

  def youku_token
    get_new_plant 
  end

  def refresh_youkutoken
    get_new_plant
    old_token = @new_plant.youku_token
    if @new_plant.refresh_youku_token
      render :youku_token
    else
      render :json => { :success => false, :old_token => old_token }
    end
  end

  def tudou_auth

  end

  def cancel_tudou_auth

  end
end
