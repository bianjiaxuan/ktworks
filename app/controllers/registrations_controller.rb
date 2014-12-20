class RegistrationsController < Devise::RegistrationsController
  def new
    if params[:invited_by]
      cookies[:invited_by] = { :value => params[:invited_by], :expires => Time.now + 3600*24}
    end
    super
  end

  # def create
  #   return render :json => sign_up_params
  #   #return
  #   # return
  #   @user = User.new(params.require(:user).permit(:email,:password,:mobile))
  #   #@user.nickname = params[:user][:]`
  #   if captcha_valid? params[:captcha]
  #     #return render :text => "ok"
  #     super
  #   else
  #     flash[:alert] = "验证码错误"
  #     render :new
  #   end
  # end


  def create
    build_resource
    resource.email = params[:user][:email]
    resource.password = params[:user][:password]
    resource.password_confirmation = params[:user][:password]
    resource.nickname = params[:user][:email]

    if params[:way] == "mobile"
      phone = params[:user][:phone]
      if phone.blank?
        flash[:alert] = "手机必须填写"
        return render :new
      end

      if params[:authcode].blank?
        flash[:alert] = "手机验证码必须填写"
        return render :new
      end

      user = User.where(:phone => phone).first
      if user.present?
        flash[:alert] = "该手机用户已经注册过了"
        return render :new
      end

      code = Rails.cache.read "register_authcode_#{phone}"
      if code != params[:authcode]
        flash[:alert] = "手机验证码不正确"
        return render :new
      end

      resource.phone = phone
      resource.email = phone + "@kicktempo.cn"
      resource.nickname = phone
      resource.vip_count = 3
    elsif params[:way] == "email"
      unless captcha_valid? params[:captcha]
        flash[:alert] = "验证码错误"
        @user = resource
        return render :new
      end
    end

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)

        if params[:way] == "email"
          resource.send :send_on_create_confirmation_instructions
        end

        # resource.confirmation_token = Devise.token_generator.digest(resource, :confirmation_token, resource.confirmation_token)
        # resource.save

        #return render :text => resource.confirmation_token

        Rails.cache.write "register_authcode_#{phone}",nil

        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      flash[:alert] = resource.errors.full_messages.join(" | ")
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      respond_with resource
    end

  end



  def authuser_update
    self.resource = resource_class.to_adapter.get!(send(:"current_user").to_key)

    if resource.password.blank? && resource.update_attributes(params[resource_name])
      if is_navigational_format?
        if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
          flash_key = :update_needs_confirmation
        end
        set_flash_message :notice, flash_key || :updated
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      resource.encrypted_password = nil
      resource.authuser_updating = true
      respond_with resource
    end
  end

  def get_authcode
    if request.post?
      phone = params[:phone]
      _code = create_authcode
      Rails.cache.write "register_authcode_#{phone}",_code
      SMS3.sendto phone,"KT足球注册验证码:#{_code}"
      render :text => 1
    end
  end

  private
  def after_sign_in_path_for(resource)
    root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :phone)
    end
  end

  def create_authcode
    s = ""
    6.times do
      s += rand(10).to_s
    end
    s
  end

end
