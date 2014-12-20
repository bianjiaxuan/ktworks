# encoding: utf-8
class AuthenticationsController < Devise::OmniauthCallbacksController

  def weibo
    omniauth_process
  end

  def renren
    omniauth_process
  end

  def qq_connect
    omniauth_process
  end

  def failure
    set_flash_message :alert, :failure, :kind => failed_strategy.name.to_s.humanize, :reason => failure_message
    redirect_to after_omniauth_failure_path_for(resource_name)
  end

  protected

  def omniauth_process
    omniauth = request.env['omniauth.auth']

    authentication = Authentication.where(provider: omniauth.provider, uid: omniauth.uid.to_s).first
    if authentication
      authentication.update_token_form_hash(omniauth)
      set_flash_message(:notice, :signed_in)
      sign_in_and_redirect authentication.user, :event => :authentication
    elsif current_user
      authentication = Authentication.create_from_hash(current_user.id, omniauth)
      set_flash_message(:notice, :add_provider_success)
      redirect_to root_path
    else
      user = User.new_with_omniauth(omniauth)
      user.save
      user.confirm!
      sign_in(user)
      set_flash_message(:notice, :fill_your_infos)

      redirect_to profile_change_path
    end
  end

  def after_omniauth_failure_path_for(scope)
    if current_user
      root_path
    else
      sign_up_path
    end
  end

end
