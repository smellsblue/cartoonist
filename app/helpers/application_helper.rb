module ApplicationHelper
  def selected(a, b = true)
    if a == b
      'selected="selected"'.html_safe
    end
  end

  def markdown(text)
    Markdown.render text
  end

  def licensed!
    @licensed = true
  end

  def licensed?
    @licensed
  end

  def mobile?
    @mobile
  end

  def html_class
    if mobile?
      "m"
    else
      "www"
    end
  end

  def enable_disqus!(options)
    @disqus_enabled = true
    @disqus_options = options
  end

  def show_social_links?
    @comic || @post
  end

  def preview?
    @for_preview
  end

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

  def current_url
    if preview?
      "/comic_admin/preview"
    else
      "/"
    end
  end

  def comic_url(number)
    if preview?
      "/comic_admin/#{number}/preview"
    else
      "/#{number}"
    end
  end

  def comic_img_url
    if preview?
      @comic.preview_img_url
    else
      @comic.img_url
    end
  end

  def random_url
    if preview?
      "/comic_admin/preview_random"
    else
      "/random"
    end
  end

  def content_license_url
    "http://creativecommons.org/licenses/by-nc/3.0/"
  end

  def copyright_message
    year = Date.today.strftime "%Y"
    copyright_years = Cartoonist::Application.config.copyright_starting_year.to_s
    copyright_years = "#{copyright_years}-#{year}" if year != copyright_years
    "&copy; #{h copyright_years} #{h Cartoonist::Application.config.copyright_owners}".html_safe
  end

  def rss_path
    if @post
      "/blog/feed"
    else
      "/feed"
    end
  end

  def rss_title
    if @post
      "RSS Feed for the #{Cartoonist::Application.config.site_name} blog"
    else
      "RSS Feed for #{Cartoonist::Application.config.site_name}"
    end
  end

  def facebook_link_title
    if @comic
      "Share this comic on Facebook"
    else
      "Share this on Facebook"
    end
  end

  def twitter_link_title
    if @comic
      "Tweet about this comic"
    else
      "Tweet about this"
    end
  end

  def google_plus_link_title
    if @comic
      "Post this comic to Google Plus"
    else
      "Post this to Google Plus"
    end
  end

  def share_facebook_text_message
    if @comic
      "Check out #{@comic.title}"
    else
      "Check this out: #{@post.title}"
    end
  end

  def share_facebook_url_message
    if @comic
      "http://#{Cartoonist::Application.config.domain}/#{@comic.number}"
    else
      "http://#{Cartoonist::Application.config.domain}/blog/#{@post.url_title}"
    end
  end

  def share_twitter_message
    if @comic
      "Check out #{@comic.title}: http://#{Cartoonist::Application.config.domain}/#{@comic.number}"
    else
      "Check this out: http://#{Cartoonist::Application.config.domain}/blog/#{@post.url_title}"
    end
  end

  def share_google_plus_message
    if @comic
      "http://#{Cartoonist::Application.config.domain}/#{@comic.number}"
    else
      "http://#{Cartoonist::Application.config.domain}/blog/#{@post.url_title}"
    end
  end
end
