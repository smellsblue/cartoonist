class Page < ActiveRecord::Base
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

    def posted
      where "posted_at IS NOT NULL"
    end

    def unposted
      where "posted_at IS NULL"
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
