module Cartoonist
  class Asset
    @@all = []
    @@included_js = []

    class << self
      # This does not include javascript files included in
      # application.js.  This is purely standalone assets.
      def all
        @@all
      end

      # Include the following js files into application.js.
      def include_js(*js_files)
        @@included_js.push *js_files
        @@included_js.tap &:uniq!
      end

      def included_js
        @@included_js
      end

      def included_js?
        @@included_js.present?
      end

      def add(*assets)
        @@all.push *assets
        @@all.tap &:uniq!
      end
    end
  end

  class Theme
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
        Cartoonist::Asset.add *assets
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
end

CartoonistThemes = Cartoonist::Theme
