class BlogPost < ActiveRecord::Base
  include Postable
  include Entity
  include Lockable
  entity_type :blog
  entity_global_url "/blog"
  entity_url &:url
  entity_preview_url &:preview_url
  entity_edit_url &:edit_url
  entity_description &:title
  attr_accessor :for_preview
  belongs_to :site

  def to_backup_entries
    post = Backup::Entry.new id, url_title, "markdown", content
    meta = Backup::Entry.new id, "#{url_title}.meta", "json", to_json(:except => :content)
    [post, meta]
  end

  def url
    "/blog/#{url_title}"
  end

  def preview_url
    "/admin/blog/#{url_title}/preview"
  end

  def edit_url
    "/admin/blog/#{id}/edit"
  end

  def first_post
    return @first_post if @first_post_retrieved
    @first_post_retrieved = true
    @first_post ||= BlogPost.first_post
  end

  def first_url_title
    first_post.url_title if first_post
  end

  def newest_post
    return @newest_post if @newest_post_retrieved
    @newest_post_retrieved = true
    @newest_post ||= BlogPost.newest_post
  end

  def newest_preview_post
    return @newest_preview_post if @newest_preview_post_retrieved
    @newest_preview_post_retrieved = true
    @newest_preview_post ||= BlogPost.newest_preview_post
  end

  def newest_id
    newest_post.id if newest_post
  end

  def newest_preview_id
    newest_preview_post.id if newest_preview_post
  end

  def oldest?
    url_title == first_url_title
  end

  def newest?
    id == newest_id
  end

  def newest_preview?
    id == newest_preview_id
  end

  def previous_post
    return @previous_post if @previous_post_retrieved

    if posted_at
      @previous_post_retrieved = true
      @previous_post ||= BlogPost.previous_post(self)
    elsif for_preview
      @previous_post_retrieved = true
      @previous_post ||= BlogPost.preview_current
    end
  end

  def next_post
    return @next_post if @next_post_retrieved

    if posted_at
      @next_post_retrieved = true
      @next_post ||= BlogPost.next_post(self)
    end
  end

  def prev_url_title
    previous_post.url_title if previous_post
  end

  def next_url_title
    next_post.url_title if next_post
  end

  def real?
    url_title
  end

  class << self
    def search(query)
      reverse_chronological.where "LOWER(title) LIKE :query OR LOWER(url_title) LIKE :query OR LOWER(content) LIKE :query OR LOWER(author) LIKE :query", :query => "%#{query.downcase}%"
    end

    def create_post(current_user, params)
      url_title = url_titlize params[:title]
      create :title => params[:title], :url_title => url_title, :content => params[:content], :author => current_user.name, :locked => true
    end

    def update_post(params)
      post = find params[:id].to_i
      post.ensure_unlocked!
      original_url_title = post.url_title
      post.title = params[:title]
      post.url_title = url_titlize params[:title]
      post.author = params[:author]
      post.content = params[:content]
      post.locked = true
      post.post_from params
      post.save!
      post
    end

    def url_titlize(title)
      title.downcase.gsub(" ", "-").gsub(/[^-_a-z0-9]/, "")
    end

    def newest_preview_post
      reverse_chronological.first || new(:title => "No Posts Yet", :content => "There are no blog posts yet.")
    end

    def newest_post
      posted.reverse_chronological.first || new(:title => "No Posts Yet", :content => "There are no blog posts yet.")
    end

    def first_post
      posted.chronological.first || new(:title => "No Posts Yet", :content => "There are no blog posts yet.")
    end

    def all_columns
      select "blog_posts.*"
    end

    def current
      post = posted.reverse_chronological.first
      post = new :title => "No Posts Yet", :content => "There are no blog posts yet." unless post
      post
    end

    def preview_current
      post = reverse_chronological.first
      post = new :title => "No Posts Yet", :content => "There are no blog posts yet." unless post
      post.for_preview = true
      post
    end

    def previous_post(post)
      context = BlogPost
      context = posted unless post.for_preview
      context.where("blog_posts.posted_at < ?", post.posted_at).reverse_chronological.first
    end

    def next_post(post)
      context = BlogPost
      context = posted unless post.for_preview
      context.where("blog_posts.posted_at > ?", post.posted_at).chronological.first
    end

    def from_url_title(url_title)
      post = posted.where(:url_title => url_title).first
      raise ActiveRecord::RecordNotFound.new("No records found!") unless post
      post
    end

    def preview_from_url_title(url_title)
      post = where(:url_title => url_title).first
      raise ActiveRecord::RecordNotFound.new("No records found!") unless post
      post.for_preview = true
      post
    end

    def archives(preview = false)
      context = BlogPost
      context = posted unless preview
      context.reverse_chronological.select([:url_title, :title, :posted_at]).to_a
    end

    def feed
      posted.reverse_chronological.take 10
    end

    def sitemap
      posted.reverse_chronological.to_a
    end
  end
end
