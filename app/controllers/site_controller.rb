class SiteController < CartoonistController
  def favicon
    respond_to do |format|
      format.html { redirect_to "/" }

      format.ico do
        data = ActionController::Base.helpers.asset_paths.asset_environment[Cartoonist::Theme.favicon].to_s

        cache_page_as "static/favicon.ico" do
          send_data data, :filename => "favicon.ico", :type => "image/x-icon", :disposition => "inline"
        end
      end
    end
  end

  def robots
    respond_to do |format|
      format.html { redirect_to "/" }

      format.text do
        cache_page_as "static/robots.txt" do
          render :layout => false
        end
      end
    end
  end

  def sitemap
    respond_to do |format|
      format.html { redirect_to "/" }

      format.xml do
        @entries = load_sitemap_content
        render :content_type => "application/xml", :layout => "cartoonist"
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
