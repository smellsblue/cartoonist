class CartoonistThemes
  @@all = []
  @@themes = {}
  @@assets = []

  class << self
    def all
      @@all
    end

    def add(theme, options)
      (@@all << theme.to_sym).sort! unless @@all.include? theme.to_sym
      @@themes[theme.to_sym] = options unless @@themes.include? theme.to_sym
    end

    def add_assets(*assets)
      assets.each do |asset|
        @@assets << asset unless @@assets.include? asset
      end
    end

    def assets
      @@assets
    end

    def [](key)
      @@themes[key.to_sym] || {}
    end

    def current
      self[Setting[:theme]]
    end

    def favicon
      current[:favicon]
    end

    def css
      current[:css]
    end

    def rss_logo
      current[:rss_logo]
    end
  end
end
