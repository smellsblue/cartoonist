class SettingsController < ApplicationController
  before_filter :ensure_ssl!
  before_filter :check_admin!, :except => [:initial_setup, :save_initial_setup]

  def index
    redirect_to "/settings/general"
  end

  def show
    @tab = Setting::Tab[params[:id]]
    render :layout => "admin"
  end

  def update
    params[:included_settings].each do |setting|
      Setting[setting] = params[setting]
    end

    redirect_to "/settings/#{params[:id]}"
  end

  def initial_setup
    return redirect_to "/admin/sign_in" unless initial_setup_required?
    render :layout => "sign_in"
  end

  def save_initial_setup
    return redirect_to "/admin/sign_in" unless initial_setup_required?
    Setting[:admin_users] = { params[:admin_username] => { :name => params[:admin_name], :password => params[:admin_password] } }
    Setting[:domain] = params[:domain]
    Setting[:site_name] = params[:site_name]
    Setting[:secret_token] = SecureRandom.hex 30
    redirect_to "/admin/sign_in"
  end
end
