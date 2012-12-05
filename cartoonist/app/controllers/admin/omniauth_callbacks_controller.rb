class Admin::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable
  skip_before_filter :verify_authenticity_token

  def failure
    if current_user
      set_flash_message(:message, :failure, :kind => "GMail", :reason => "association failed") if is_navigational_format?
      redirect_to "/admin/accounts/#{current_user.id}"
    else
      set_flash_message(:notice, :failure, :kind => "GMail", :reason => "login failed") if is_navigational_format?
      redirect_to "/admin"
    end
  end

  def google
    auth = request.env["omniauth.auth"]
    user = User.from_auth auth

    if current_user
      if !user
        current_user.save_auth! auth
        set_flash_message(:message, :success, :kind => "GMail") if is_navigational_format?
        return redirect_to "/admin/accounts/#{current_user.id}"
      end
    end

    if user
      sign_in user, :event => :authentication
      remember_me user
      set_flash_message(:message, :success, :kind => "GMail") if is_navigational_format?
    else
      set_flash_message(:notice, :failure, :kind => "GMail", :reason => "login failed") if is_navigational_format?
    end

    redirect_to "/admin"
  end
end
