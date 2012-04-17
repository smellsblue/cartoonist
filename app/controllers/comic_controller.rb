class ComicController < ApplicationController
  def index
    @comic = Comic.current
    @disabled_prev = true if @comic.oldest?
    @disabled_next = true
    @title = Setting[:site_name]
    render :show
    cache_page_as ".#{cache_type}.tmp.html" if Cartoonist::RootPath.current_key == :comics
    cache_page_as "comic.#{cache_type}.tmp.html"
  end

  def random
    redirect_to "/comic/#{rand(max_comic) + 1}"
  end

  def show
    respond_to do |format|
      format.html do
        begin
          return redirect_to "/comic/1" if params[:id].to_i < 1
          @comic = Comic.from_number params[:id], true
          @disabled_prev = true if @comic.oldest?
          @disabled_next = @comic.maybe_newest?
          render
          cache_show_page
        rescue
          redirect_to "/comic"
        end
      end

      format.png do
        comic = Comic.from_number params[:id], true
        send_data comic.database_file.content, :filename => "comic_#{comic.number}.png", :type => "image/png", :disposition => "inline"
        cache_page_as "static/comic/#{comic.number}.png"
      end
    end
  end

  def feed
    respond_to do |format|
      format.html { redirect_to "/comic" }

      format.rss do
        @feed = feed_contents
        render :content_type => "application/xml"
      end
    end
  end

  private
  def feed_contents
    result = comic_cache.read "feed"
    return result if result
    result = ComicFeed.new Comic.feed
    comic_cache.write "feed", result
    result
  end

  def max_comic
    result = comic_cache.read "max-comic"
    return result if result
    result = Comic.largest_posted_number
    comic_cache.write "max-comic", result
    result
  end

  def comic_cache
    @@comic_cache ||= ActiveSupport::Cache::MemoryStore.new(:expires_in => 2.hours)
  end

  def cache_show_page
    if @disabled_next
      cache_page_as "comic/#{@comic.number}.#{cache_type}.tmp.html"
    else
      cache_page_as "comic/#{@comic.number}.#{cache_type}.html"
    end
  end
end
