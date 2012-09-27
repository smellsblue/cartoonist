class Admin::CacheController < AdminCartoonistController
  layout "general_admin"

  def index
    @caches = PageCache.all
  end

  def destroy
    PageCache.find(params[:id]).expire!
    redirect_to "/admin/cache"
  end

  def expire_www
    PageCache.expire_www!
    redirect_to "/admin/cache"
  end

  def expire_m
    PageCache.expire_m!
    redirect_to "/admin/cache"
  end

  def expire_tmp
    PageCache.expire_tmp!
    redirect_to "/admin/cache"
  end

  def expire_all
    PageCache.expire_all!
    redirect_to "/admin/cache"
  end
end
