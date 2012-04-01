class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_mobile

  private
  def initial_setup_required?
    Setting[:admin_users].empty?
  end

  def ensure_ssl!
    return unless Rails.env.production?
    redirect_to "https://#{request.host_with_port}#{request.fullpath}" unless request.ssl?
  end

  def check_admin!
    raise ActionController::RoutingError.new("Not Found") unless session[:admin]
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
    cache_page @response, "/cache/#{path}"
  end
end
