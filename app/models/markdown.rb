class Markdown
  class << self
    def config
      @markdown ||= Redcarpet::Markdown.new Redcarpet::Render::HTML
    end

    def render(text, safe = true)
      result = config.render text

      if safe
        result.html_safe
      else
        result
      end
    end
  end
end
