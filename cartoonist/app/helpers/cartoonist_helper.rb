module CartoonistHelper
  def partial(name, locals = {}, &block)
    if block
      raise "Cannot have a 'body' local when a block is given!" if locals.include?(:body)
      locals[:body] = capture &block
    end

    render :partial => name, :locals => locals
  end

  def selected(a, b = true)
    if a == b
      'selected="selected"'.html_safe
    end
  end

  def checked(a, b = true)
    if a == b
      'checked="checked"'.html_safe
    end
  end

  def format_time(time, fmt)
    if time
      time.localtime.strftime fmt
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

  def rss!(path, title)
    @rss_path = path
    @rss_title = title
  end

  def rss?
    @rss_path
  end

  def rss_path
    @rss_path
  end

  def rss_title
    @rss_title
  end

  def mobile?
    @mobile
  end

  def enable_disqus!(options)
    @disqus_enabled = true
    @disqus_options = options
  end

  def preview?
    @for_preview
  end

  def content_license_url
    "http://creativecommons.org/licenses/by-nc/3.0/"
  end

  def copyright_message
    year = Date.today.strftime "%Y"
    copyright_years = Setting[:copyright_starting_year].to_s
    copyright_years = "#{copyright_years}-#{year}" if year != copyright_years
    "&copy; #{h copyright_years} #{h Setting[:copyright_owners]}".html_safe
  end
end
