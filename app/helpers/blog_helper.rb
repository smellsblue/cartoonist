module BlogHelper
  def blog_current_url
    if preview?
      "/blog_admin/preview"
    else
      "/blog"
    end
  end

  def blog_post_url(url_title)
    if preview?
      "/blog_admin/#{url_title}/preview"
    else
      "/blog/#{url_title}"
    end
  end
end
