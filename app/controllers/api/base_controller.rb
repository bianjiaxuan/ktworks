# -*- coding: utf-8 -*-
class Api::BaseController < ApplicationController
  respond_to :json
  before_filter :force_json_format
  skip_before_filter :verify_authenticity_token
  # before_filter :authenticate!
  
  helper_method :current_api_user


  class UnAuthorizeError < StandardError
  end

  if Rails.env == 'production'
    rescue_from Exception, :with => :render_server_error
    rescue_from UnAuthorizeError, :with => proc { head :forbidden }
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  end

  def force_json_format
    request.format = 'json'
  end

  def require_login
    raise UnAuthorizeError unless current_api_user
  end

  def current_api_user
    User.find_by_authentication_token(request.env['HTTP_ACCESSTOKEN']) unless request.env['HTTP_ACCESSTOKEN'].nil?
  end

  def authenticate!
    if current_api_user.blank?
      render :json => {:success => false, :message => 'UnAuthorizeError'}, :status => 401
    end
  end

  def render_not_found
    render :json => { :success => false, :error => '你所查找的记录不存在!' }, :status => 404
  end

  def render_server_error
    render :json => { :success => false, :error => 'Error in server!' }, :status => 500
  end

end
