class CartoonistController < ActionController::Base
  helper :cartoonist
  protect_from_forgery
  before_filter :load_site_and_domain
  before_filter :verify_site_enabled!
  before_filter :verify_domain_enabled!

  private
  def load_site_and_domain
    @this_domain = Domain.from_name request.domain(100)
    @this_site = @this_domain.site
  end

  def verify_site_enabled!
    raise ActionController::RoutingError.new("Site Disabled") if @this_site.disabled?
  end

  def verify_domain_enabled!
    raise ActionController::RoutingError.new("Site Disabled") if @this_domain.disabled?
  end

  def handle_unverified_request
    raise ActionController::InvalidAuthenticityToken.new
  end

  def cache_type
    "www"
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
