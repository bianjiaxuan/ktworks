# -*- coding: utf-8 -*-
class Api::UsersController < Api::BaseController
  before_filter :authenticate!, :only => [:update_profile, :user_info, :auth_connect, :auth_info]

  def auth_connect
    @user = current_api_user
    valid_provider = ['weibo', 'qq_connect', 'renren']
    if !valid_provider.include?(params[:provider])
      render :json => { :success => false, :message => '平台错误。' }
    elsif @user.authentications.find_by_provider(params[:provider])
      render :json => { :success => false, :message => '已绑定该平台。' }
    else
      auth = @user.authentications.new(:uid => params[:uid], :provider => params[:provider], :access_token => params[:token])
      if auth.save
        render :json => { :success => true, :message => '绑定成功。' }
      else
        render :json => { :success => false, :message => auth.errors.messages }
      end
    end
  end

  def auth_info
    @user = current_api_user
    @auths = @user.authentications
  end

  def auth_redirect_uri
  end

  def share
    valid_provider = ['weibo', 'qq_connect', 'renren']
    if !valid_provider.include?(params[:provider])
      render :json => { :success => false, :message => '平台错误。' }
    else
      result = current_api_user.share_info(params[:provider])
      if result[:success]
        render :json => { :success => true, :message => '分享成功。' }
      else
        render :json => { :success => false, :message => result[:message] }
      end
    end
  end

  def user_info
    @user = current_api_user
    render :login
  end

  def base_info
    @user = User.find_by_id(params[:user_id])
    if params[:game_mode].blank? || ( params[:game_mode].present? && params[:game_mode] == "1" )
      if @user &&  !@user.vip_login_check
        @user = nil
        render :json => { :success => false, :message => '哦，请及时充值或续费；不然您不能继续KT' }
      end
    end
  end

  def update_profile
    @user = current_api_user
    if @user.profile.nil?
      # 先保存profile
      profile = UserProfile.create(params[:profile])
      profile.user = @user
      profile.save
    else
      @user.profile.update_attributes(params[:profile])
    end

    if params[:nickname].present?
      if @user.update_attributes(:nickname => params[:nickname],:city=>@user.profile.city)
        render :json => { :success => true, :message => '更新成功。' }
      else
        render :json => { :success => false, :message => @user.errors.messages }
      end
    else
      render :json => { :success => true, :message => '更新成功。' }
    end
  end

  def login
    render :json => 'email and password should be presence!', :status => 400  and return  if params[:email].blank? || params[:password].blank?
    @user = User.authenticate(params[:email], params[:password])
    render :json => 'vip expired ! recharge please.', :status => 400  and return if @user && @user.is_vip && ! @user.vip_login_check
    
    @user.reset_authentication_token! if @user
    
    render
    
  end

  def sign_up
    # 'user[email]' => 'hahahhaha@gmail.com',
    # 'user[nickname]' => 'rice',
    # 'user[password]' => '123456',
    # 'user[password_confirmation]' => '123456',
    # 'user[phone]' => '1232131',
    # 'user[sex]' => 'MM',
    # 'user[birthday]' => '2010-10-01',
    # 'user[province]' => 'anhjui',
    # 'user[city]' => 'hehe',
    # 'user[area]' => 'home'
=begin    
    @user = User.new(params[:user])
    @user.source= User::SOURCE_APP
    if @user.save
      #@user.confirm!
      render :login
    else
      render :json => { :success => false, :messages => @user.errors.messages }
    end
=end    
    render :json => { :success => false, :messages => "Nowadays registration is not supported" }
  end

  def vedios
    @user = User.find(params[:id])
    @vedios = @user.game_vedios.page(params[:page]).per(10)
    render 'api/game_vedios/index'
  end

  def oauth_login
    @user = Authentication.find_by_uid_and_provider(params[:oauth_uid], params[:provider]).
      try(:user)
    if @user
      render :login
    else
      render json: { oauth: false,
                     message: "can't find this oauth user. post user profile & OauthInfo to signup and login." }
    end
  end

  # access_token # oauth_uid # provider # nickname # gender # birthday # province # city # area
  def oauth_signup
    @user = User.new(
      nickname: params[:nickname],
      sex: params[:sex],
      phone: params[:phone],
      birthday: params[:birthday],
      province: params[:province],
      city: params[:city],
      area: params[:area] )
    @user.created_by_oauth = 'mobile'
    @user.authentications.build(
      uid: params[:oauth_uid],
      provider: params[:provider],
      access_token: params[:access_token])
    if @user.save
      @user.confirm!
      render :login
    else
      render json: {
        success: false,
        message: @user.errors.messages
      }
    end
  end

end
