class SiteController < ApplicationController
  def favicon
    respond_to do |format|
      format.html { redirect_to "/" }

      format.ico do
        path = ActionController::Base.helpers.asset_path Cartoonist::Theme.favicon
        path = File.join Rails.root, "public", path
        send_data File.read(path), :filename => "favicon.ico", :type => "image/x-icon", :disposition => "inline"
        cache_page_as "static/favicon.ico"
      end
    end
  end

  def robots
    respond_to do |format|
      format.html { redirect_to "/" }

      format.text do
        render :layout => false
        cache_page_as "static/robots.txt"
      end
    end
  end

  def sitemap
    respond_to do |format|
      format.html { redirect_to "/" }

      format.xml do
        @entries = load_sitemap_content
        render :content_type => "application/xml"
      end
    end
  end

  private
  def load_sitemap_content
    result = site_cache.read "sitemap-entries"
    return result if result
    result = Cartoonist::Sitemap.all
    site_cache.write "sitemap-entries", result
    result
  end

  def site_cache
    @@site_cache ||= ActiveSupport::Cache::MemoryStore.new(:expires_in => 2.hours)
  end
end
