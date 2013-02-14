class CartoonistController < ActionController::Base
  helper :cartoonist
  protect_from_forgery
  before_filter :load_site_and_domain
  before_filter :verify_site_enabled!
  before_filter :verify_domain_enabled!

  private
  def load_site_and_domain
    @domain = Domain.from_name request.domain(100)
    @site = @domain.site
  end

  def verify_site_enabled!
  end

  def verify_domain_enabled!
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
