class ComicController < CartoonistController
  def index
    @comic = Comic.current
    @disabled_prev = true if @comic.oldest?
    @disabled_next = true
    @title = Setting[:site_name]

    cache_page_as "comic.#{cache_type}.tmp.html" do
      render :show
      cache_page_as ".#{cache_type}.tmp.html" if Cartoonist::RootPath.current_key == :comics
    end
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

          cache_page_as show_page_cache_path do
            render
          end
        rescue
          redirect_to "/comic"
        end
      end

      format.png do
        comic = Comic.from_number params[:id], true

        cache_page_as "static/comic/#{comic.number}.png" do
          send_data comic.database_file.content, :filename => "comic_#{comic.number}.png", :type => "image/png", :disposition => "inline"
        end
      end
    end
  end

  def feed
    respond_to_feed "feed"
  end

  def mfeed
    respond_to_feed "mfeed"
  end

  private
  def respond_to_feed(name)
    respond_to do |format|
      format.html { redirect_to "/comic" }

      format.rss do
        @feed = ComicFeed.new Comic.feed

        cache_page_as "comic/#{name}.#{cache_type}.tmp.rss" do
          render :content_type => "application/xml", :layout => "cartoonist"
        end
      end
    end
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

  def show_page_cache_path
    if @disabled_next
      "comic/#{@comic.number}.#{cache_type}.tmp.html"
    else
      "comic/#{@comic.number}.#{cache_type}.html"
    end
  end
end
