class StaticCacheController < CartoonistController
  before_filter :ensure_ssl!
  before_filter :check_admin!
  layout "general_admin"

  def index
    @caches = StaticCache.all
  end

  def destroy
    StaticCache.find(params[:id]).expire!
    redirect_to "/static_cache"
  end

  def expire_all
    StaticCache.expire_all!
    redirect_to "/static_cache"
  end
end
