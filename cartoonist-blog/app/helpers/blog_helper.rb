module BlogHelper
  def blog_archives_url
    if preview?
      "/admin/blog/archives"
    else
      "/blog/archives"
    end
  end

  def blog_current_url
    if preview?
      "/admin/blog/preview"
    else
      "/blog"
    end
  end

  def blog_post_url(url_title)
    if preview?
      "/admin/blog/#{url_title}/preview"
    else
      "/blog/#{url_title}"
    end
  end
end
