class SessionsController < Devise::SessionsController
  #after_filter :reset_last_captcha_code!
  # before_filter :configure_permitted_parameters
  #skip_before_filter :require_no_authentication, :only => [ :new, :create ]

  def new
    flash[:alert] = "请检查信息有效性"
    redirect_to "/newhome/login"
  end

  # def create
  #   render :json => params
  # end

  # def create
  #   @user = User.new(sign_in_params)

  #   self.resource = warden.authenticate!(auth_options)
  #   user = User.where(params.require(:user).permit(:email,:company)).first
  #   if user && user.valid_password?(params[:user][:password])
  #     #if user.confirmed_at?
  #       set_flash_message(:notice, :signed_in) if is_navigational_format?
  #       sign_in(:user, user)
  #       user.create_base
  #       redirect_to "/"
  #       #respond_with user, :location => after_sign_in_path_for(user)
  #     # else
  #     #   flash[:alert] = "您的账号未激活"
  #     #   render :new
  #     # end
  #   else
  #     flash[:alert] = "请检查信息有效性"
  #     render :new
  #   end

  # end

  # def destroy
  #   if current_user.present?
  #     super
  #   else
  #     redirect_to root_path
  #   end
  # end

  # def check_captcha
  #   is_checked = captcha_valid?(params[:captcha]) ? 1 : 0
  #   render json: {:status => "success", :is_checked => is_checked}
  # end

  # private

  # def default_after_sign_in_path

  # end

  # protected
  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.for(:sign_up) { |u| u.permit( :email, :password, :password_confirmation, :remember_me) }
  #   devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(  :email, :password, :remember_me, :company) }
  # end

end