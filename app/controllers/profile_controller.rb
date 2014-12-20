# -*- coding: utf-8 -*-
class ProfileController < InheritedResources::Base
  before_filter :authenticate_user!
  respond_to :html, :json

  def change
  	if current_user.profile.nil?
      UserProfile.create(:user_id => current_user.id)
      #else
  	  #return redirect_to new_profile_path
  	end

    return redirect_to edit_profile_path(current_user)
  end

  def edit
  	@user_profile = current_user.profile
    render :action => :new
  end

  def new
    @user_profile = UserProfile.new
  end

  def create

  	redirect_to :back
  end

  def update
    if params[:user_profile][:province].blank?
      params[:user_profile][:province] = params[:old_province]
    end

    if params[:user_profile][:city].blank?
      params[:user_profile][:city] = params[:old_city]
    end

    if params[:user_profile][:area].blank?
      params[:user_profile][:area] = params[:old_area]
    end

    if current_user.profile.nil?
      # 先保存profile
      profile = UserProfile.create(params[:user_profile])
      profile.user = current_user
      profile.save
    else
      current_user.profile.update_attributes(params[:user_profile])
    end

    # 保存nickname
    current_user.nickname = params[:nickname]
    current_user.email = params[:email]
    current_user.city = params[:user_profile][:city]
    begin
      if current_user.save
        flash[:updated] = true
        return redirect_to "/user/#{current_user.id}"
      else
        if params[:nickname].length > 20 || params[:nickname].length < 5
          flash[:error] = "昵称长度需在 5 到 20 个字符之间"
        else
          flash[:error] = current_user.errors.full_messages.join("  ")
        end
      end
    rescue => e
      p "Other error : " + e.to_s
    end
    # redirect_to "/user/#{current_user.id}"
    redirect_to :back
  end

  # 上传个人头像页面
  def avatar
    if current_user.profile.nil?
      @user_profile = UserProfile.create(:user_id => current_user.id)
    else
      @user_profile = current_user.profile
    end
  end

  # 上传个人头像
  def upload_avatar
    if params[:user_profile][:avatar].size > 1024 * 1024
      flash[:error] = "上传的图片超过系统限定的1mb"
      return redirect_to profile_avatar_path
    end


    if current_user.profile.nil?
      profile = UserProfile.create(:user_id => current_user.id)
    end
    is_saved = current_user.profile.update_attributes(params[:user_profile])

    if is_saved
      flash[:notice] = "上传成功"
    else
      flash[:error] = "上传的图片不符合要求"
    end

    return redirect_to profile_avatar_path
  end

  def show
  end

  def checkemail
    result=0
    mail_reg=/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,3})\Z/i
    if mail_reg.match(params[:email])==nil
      render :text => result
      return
    end
    user = User.find_by_email (params[:email])
    if !user || user && user.id == params[:id].to_i
      result=1
    end
    render :text => result
  end


end
