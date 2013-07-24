class Page < ActiveRecord::Base
  include Postable
  include Entity
  include Lockable
  entity_type :page
  entity_url &:url
  entity_preview_url &:preview_url
  entity_edit_url &:edit_url
  entity_description &:title

  def to_backup_entries
    page = Backup::Entry.new id, path, "markdown", content
    meta = Backup::Entry.new id, "#{path}.meta", "json", to_json(:except => :content)
    [page, meta]
  end

  def url
    "/#{path}"
  end

  def preview_url
    "/admin/page/#{path}/preview"
  end

  def edit_url
    "/admin/page/#{id}/edit"
  end

  def has_comments?
    comments
  end

  def in_sitemap?
    in_sitemap
  end

  class << self
    def create_page(params)
      path = params[:path].downcase
      raise "Invalid path" unless path =~ /^[-_a-z0-9]+$/
      Page.create :title => params[:title], :path => path, :content => params[:content], :locked => true
    end

    def update_page(params)
      path = params[:path].downcase
      raise "Invalid path" unless path =~ /^[-_a-z0-9]+$/
      page = Page.find params[:id].to_i
      page.ensure_unlocked!
      page.title = params[:title]
      page.path = path
      page.content = params[:content]
      page.locked = true
      page.comments = !!params[:comments]
      page.in_sitemap = !!params[:in_sitemap]

      if params[:posted]
        page.posted_at = Date.today
      else
        page.posted_at = nil
      end

      page.save!
      page
    end

    def search(query)
      ordered.where "LOWER(title) LIKE :query OR LOWER(path) LIKE :query OR LOWER(content) LIKE :query", :query => "%#{query.downcase}%"
    end

    def sitemap
      posted.in_sitemap
    end

    def in_sitemap
      where :in_sitemap => true
    end

    def ordered
      order "pages.title ASC"
    end

    def preview_from_path(path)
      page = where(:path => path).first
      raise ActiveRecord::RecordNotFound.new("No page found!") unless page
      page
    end

    def from_path(path)
      page = posted.where(:path => path).first
      raise ActiveRecord::RecordNotFound.new("No page found!") unless page
      page
    end
  end
end
