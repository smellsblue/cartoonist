class Markdown
  class LinkToAbsoluteRenderer < Redcarpet::Render::HTML
    def link(link, title, content)
      link = "http://#{Setting[:domain]}#{link}" if link =~ /^\//
      title = %{ title="#{title}"} if title
      %{<a href="#{link}"#{title}>#{content}</a>}
    end
  end

  class << self
    RENDER_DEFAULTS = { :html_safe => true, :link_to_absolute => false }

    def standard_renderer
      @standard_renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    end

    def link_to_absolute_renderer
      @link_to_absolute_renderer ||= Redcarpet::Markdown.new(LinkToAbsoluteRenderer.new)
    end

    def render(text, options = {})
      options = RENDER_DEFAULTS.merge options

      if options[:link_to_absolute]
        result = link_to_absolute_renderer.render text
      else
        result = standard_renderer.render text
      end

      if options[:html_safe]
        result.html_safe
      else
        result
      end
    end
  end
end
