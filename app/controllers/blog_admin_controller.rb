class BlogAdminController < CartoonistController
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
    post = BlogPost.create_post current_user, params
    redirect_to "/blog_admin/#{post.id}/edit"
  end

  def edit
    @post = BlogPost.find params[:id].to_i
  rescue ActiveRecord::RecordNotFound
    redirect_to "/blog_admin/new"
  end

  def update
    post = BlogPost.update_post params
    redirect_to "/blog_admin/#{post.id}/edit"
  end

  def lock
    post = BlogPost.find params[:id].to_i
    post.lock!
    redirect_to "/blog_admin/#{post.id}/edit"
  end

  def unlock
    post = BlogPost.find params[:id].to_i
    post.unlock!
    redirect_to "/blog_admin/#{post.id}/edit"
  end
end
