class SettingsController < CartoonistController
  before_filter :ensure_ssl!
  before_filter :check_admin!, :except => [:initial_setup, :save_initial_setup]

  def index
    redirect_to "/settings/general"
  end

  def show
    @tab = Setting::Tab[params[:id]]
    render :layout => "general_admin"
  end

  def update
    params[:included_settings].each do |setting|
      Setting[setting] = params[setting]
    end

    redirect_to "/settings/#{params[:id]}"
  end

  def initial_setup
    return redirect_to "/admin" unless initial_setup_required?
    render :layout => "initial_setup"
  end

  def save_initial_setup
    return redirect_to "/admin" unless initial_setup_required?
    Setting[:domain] = params[:domain]
    Setting[:site_name] = params[:site_name]
    Setting[:secret_token] = SecureRandom.hex 30
    Setting[:devise_pepper] = SecureRandom.hex 64
    # This MUST go AFTER we set the pepper
    User.create! :email => params[:admin_email], :password => params[:admin_password], :name => params[:admin_name]
    redirect_to "/admin"
  end
end
