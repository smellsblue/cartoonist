class CartoonistAssets
  @@all = []

  class << self
    def all
      @@all
    end

    def add(*assets)
      assets.each do |asset|
        @@all << asset unless @@all.include? asset
      end
    end
  end
end

class CartoonistThemes
  @@all = []
  @@themes = {}

  class << self
    def all
      @@all
    end

    def add(theme, options)
      (@@all << theme.to_sym).sort! unless @@all.include? theme.to_sym
      @@themes[theme.to_sym] = options unless @@themes.include? theme.to_sym
    end

    def add_assets(*assets)
      CartoonistAssets.add *assets
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
