class CartoonistController < ActionController::Base
  helper :cartoonist
  protect_from_forgery
  before_filter :check_mobile

  private
  def initial_setup_required?
    User.count == 0
  end

  def ensure_ssl!
    return unless Rails.env.production?
    redirect_to "https://#{request.host_with_port}#{request.fullpath}" unless request.ssl?
  end

  def check_admin!
    if initial_setup_required?
      redirect_to "/admin/settings/initial_setup"
    else
      authenticate_user!
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    "/admin"
  end

  def after_sign_in_path_for(resource_or_scope)
    "/admin"
  end

  def check_mobile
    @mobile = (request.subdomain == "m") || params[:mobile]
  end

  def preview!
    @for_preview = true
  end

  def cache_type
    if @mobile
      "m"
    else
      "www"
    end
  end

  def cache_page_as(path)
    if block_given?
      expiration = expiration_for path
      response.headers["Expires"] = CGI.rfc1123_date expiration.from_now
      expires_in expiration, :public => true
      yield
    end

    cache_page @response, "/cache/#{path}"
  end

  def expiration_for(path)
    if path =~ /\.tmp\.[^.]*$/
      2.hours
    else
      7.days
    end
  end
end
