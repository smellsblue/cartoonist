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
        @comics = Comic.sitemap
        @blog_posts = BlogPost.sitemap
        @pages = Page.sitemap
        render :content_type => "application/xml"
      end
    end
  end
end
