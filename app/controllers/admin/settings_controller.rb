class Admin::SettingsController < CartoonistController
  before_filter :ensure_ssl!
  before_filter :check_admin!, :except => [:initial_setup, :save_initial_setup]

  def index
    redirect_to "/admin/settings/general"
  end

  def show
    @tab = Setting::Tab[params[:id]]
    render :layout => "general_admin"
  end

  def update
    params[:included_settings].each do |setting|
      begin
        Setting[setting] = params[setting]
      rescue Setting::InvalidError => e
        flash[:update_errors] ||= []
        flash[:update_errors] << e.message
      end
    end

    redirect_to "/admin/settings/#{params[:id]}"
  end

  def initial_setup
    return redirect_to "/admin" unless initial_setup_required?
    render :layout => "initial_setup"
  end

  def save_initial_setup
    return redirect_to "/admin" unless initial_setup_required?

    if params[:admin_password] != params[:admin_confirm_password]
      flash[:error] = t "settings.initial_setup.passwords_dont_match"
      return redirect_to "/admin/settings/initial_setup"
    end

    Setting[:copyright_starting_year] = Date.today.strftime("%Y").to_i
    Setting[:domain] = params[:domain]
    Setting[:site_name] = params[:site_name]
    Setting[:secret_token] = SecureRandom.hex 30
    Setting[:devise_pepper] = SecureRandom.hex 64
    # This MUST go AFTER we set the pepper
    User.create! :email => params[:admin_email], :password => params[:admin_password], :password_confirmation => params[:admin_confirm_password], :name => params[:admin_name]
    redirect_to "/admin"
  end
end
