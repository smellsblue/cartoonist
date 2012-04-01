class BlogController < ApplicationController
  def archives
    @posts = BlogPost.archives
    render :layout => "page"
    cache_page_as "blog/archives.#{cache_type}.tmp.html"
  end

  def show
    @post = BlogPost.from_url_title params[:id]
    @disabled_prev = @post.oldest?
    @disabled_next = @post.newest?
    render
    cache_show_page
  rescue
    redirect_to "/blog"
  end

  def index
    @post = BlogPost.current
    @disabled_prev = true if @post.oldest?
    @disabled_next = true
    @title = "Blog for #{CartoonistConfig[:site_name]}"
    render :show
    cache_page_as "blog.#{cache_type}.tmp.html"
  end

  def feed
    respond_to do |format|
      format.html { redirect_to "/blog/feed" }

      format.rss do
        @feed = feed_content
        render :content_type => "application/xml"
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

  def cache_show_page
    if @disabled_next
      cache_page_as "blog/#{@post.url_title}.#{cache_type}.tmp.html"
    else
      cache_page_as "blog/#{@post.url_title}.#{cache_type}.html"
    end
  end
end
