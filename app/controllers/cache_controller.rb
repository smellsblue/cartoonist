class CacheController < ApplicationController
  before_filter :ensure_ssl!
  before_filter :check_admin!
  layout "admin"

  def index
    @caches = PageCache.all
  end

  def destroy
    PageCache.find(params[:id]).expire!
    redirect_to "/cache"
  end

  def expire_www
    PageCache.expire_www!
    redirect_to "/cache"
  end

  def expire_m
    PageCache.expire_m!
    redirect_to "/cache"
  end

  def expire_tmp
    PageCache.expire_tmp!
    redirect_to "/cache"
  end

  def expire_all
    PageCache.expire_all!
    redirect_to "/cache"
  end
end
