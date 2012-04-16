class BlogAdminController < ApplicationController
  helper :blog
  before_filter :preview!, :only => [:preview]
  before_filter :ensure_ssl!
  before_filter :check_admin!

  def preview
    if params[:id].present?
      begin
        @post = BlogPost.preview_from_url_title params[:id]
      rescue
        redirect_to "/blog_admin/preview"
      end

      if @post.posted_at
        @disabled_next = @post.newest_preview?
      else
        @disabled_next = true
      end
    else
      @post = BlogPost.preview_current
      @title = "Blog for #{Setting[:site_name]}"
      @disabled_next = true
    end

    @disabled_prev = true if @post.oldest?
    render "blog/show", :layout => "blog"
  end

  def preview_content
    render :text => Markdown.render(params[:content]), :layout => false
  end

  def index
    @unposted = BlogPost.unposted.chronological
    @posted = BlogPost.posted.reversed
  end

  def create
    url_title = BlogPost.url_titlize params[:title]
    post = BlogPost.create :title => params[:title], :url_title => url_title, :content => params[:content], :author => session[:user], :tweet => tweet_message(url_title), :locked => true
    redirect_to "/blog_admin/#{post.id}/edit"
  end

  def edit
    @post = BlogPost.find params[:id].to_i
  rescue ActiveRecord::RecordNotFound
    redirect_to "/blog_admin/new"
  end

  def update
    post = BlogPost.find params[:id].to_i
    raise "Cannot update locked post!" if post.locked
    original_tweet = post.tweet
    original_url_title = post.url_title
    post.title = params[:title]
    post.url_title = BlogPost.url_titlize params[:title]
    post.author = params[:author]
    post.tweet = params[:tweet]
    post.content = params[:content]
    post.locked = true

    if original_tweet == post.tweet && original_url_title != post.url_title && !post.tweeted?
      post.tweet = tweet_message post.url_title
    end

    if params[:posted] && params[:posted_at_date].present?
      time = "#{params[:posted_at_date]} #{params[:posted_at_hour]}:#{params[:posted_at_minute]} #{params[:posted_at_meridiem]}"
      time = DateTime.parse time
      time = Time.local time.year, time.month, time.day, time.hour, time.min
      post.posted_at = time
    elsif params[:posted]
      post.posted_at = 1.hour.from_now
    else
      post.posted_at = nil
    end

    post.save!
    redirect_to "/blog_admin/#{post.id}/edit"
  end

  def lock
    post = BlogPost.find params[:id].to_i
    post.locked = true
    post.save!
    redirect_to "/blog_admin/#{post.id}/edit"
  end

  def unlock
    post = BlogPost.find params[:id].to_i
    post.locked = false
    post.save!
    redirect_to "/blog_admin/#{post.id}/edit"
  end

  private
  def tweet_message(url_title)
    tweet = "New blog post: http://#{Setting[:domain]}/blog/#{url_title}"
    tweet = "New blog post: http://#{Setting[:domain]}/blog" if tweet.length > 140
    tweet
  end
end
