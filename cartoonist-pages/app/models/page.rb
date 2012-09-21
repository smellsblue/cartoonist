class Page < ActiveRecord::Base
  include Postable
  include Entity
  entity_type :page
  entity_url &:url
  entity_preview_url &:preview_url
  entity_edit_url &:edit_url
  entity_description &:title
  attr_accessible :title, :path, :posted_at, :content, :locked, :comments, :in_sitemap

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