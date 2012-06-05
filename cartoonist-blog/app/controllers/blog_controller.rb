class BlogController < CartoonistController
  def archives
    @posts = BlogPost.archives

    cache_page_as "blog/archives.#{cache_type}.tmp.html" do
      render :layout => "blog_archives"
    end
  end

  def show
    @post = BlogPost.from_url_title params[:id]
    @disabled_prev = @post.oldest?
    @disabled_next = @post.newest?

    cache_page_as show_page_cache_path do
      render
    end
  rescue
    redirect_to "/blog"
  end

  def index
    @post = BlogPost.current
    @disabled_prev = true if @post.oldest?
    @disabled_next = true
    @title = "Blog for #{Setting[:site_name]}"

    cache_page_as "blog.#{cache_type}.tmp.html" do
      render :show
      cache_page_as ".#{cache_type}.tmp.html" if Cartoonist::RootPath.current_key == :blog
    end
  end

  def feed
    respond_to do |format|
      format.html { redirect_to "/blog/feed" }

      format.rss do
        @feed = feed_content
        render :content_type => "application/xml", :layout => "cartoonist"
      end
    end
  end

  private
  def feed_content
    result = blog_cache.read "blog-feed"
    return result if result
    result = BlogFeed.new BlogPost.feed
    blog_cache.write "blog-feed", result
    result
  end

  def blog_cache
    @@blog_cache ||= ActiveSupport::Cache::MemoryStore.new(:expires_in => 2.hours)
  end

  def show_page_cache_path
    if @disabled_next
      "blog/#{@post.url_title}.#{cache_type}.tmp.html"
    else
      "blog/#{@post.url_title}.#{cache_type}.html"
    end
  end
end
