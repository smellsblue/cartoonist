class CartoonistController < ActionController::Base
  helper :cartoonist
  protect_from_forgery
  before_filter :check_mobile

  private
  def handle_unverified_request
    raise ActionController::InvalidAuthenticityToken.new
  end

  def check_mobile
    @mobile = (request.subdomain == "m") || params[:mobile]
  end

  def mobile?
    @mobile
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
