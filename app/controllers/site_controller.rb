class SiteController < ApplicationController
  def favicon
    respond_to do |format|
      format.html { redirect_to "/" }

      format.ico do
        path = ActionController::Base.helpers.asset_path CartoonistThemes.favicon
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
        load_sitemap_content
        render :content_type => "application/xml"
      end
    end
  end

  private
  def load_sitemap_content
    @comics = site_cached_content("comics-sitemap") { Comic.sitemap }
    @blog_posts = site_cached_content("blog-sitemap") { BlogPost.sitemap }
    @pages = site_cached_content("pages-sitemap") { Page.sitemap }
  end

  def site_cached_content(key)
    result = site_cache.read key
    return result if result
    result = yield
    site_cache.write key, result
    result
  end

  def site_cache
    @@site_cache ||= ActiveSupport::Cache::MemoryStore.new(:expires_in => 2.hours)
  end
end
