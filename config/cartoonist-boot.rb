module Cartoonist
  module Admin
    class Tab
      attr_reader :key, :url, :order

      @@all = {}
      @@cached_order = []

      def initialize(key, options)
        @key = key
        @url = options[:url]
        @order = options[:order]
      end

      class << self
        def all
          @@cached_order
        end

        def [](key)
          @@all[key].url
        end

        def add(key, options)
          @@all[key] = Cartoonist::Admin::Tab.new key, options
          @@cached_order = @@all.values.sort do |a, b|
            if a.order && b.order
              a.order <=> b.order
            elsif a.order && !b.order
              -1
            elsif b.order && !a.order
              1
            else
              a.key <=> b.key
            end
          end.map &:key
        end
      end
    end
  end

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

  class Backup
    @@all = {}

    class << self
      def all
        @@all
      end

      def for(key, &block)
        @@all[key.to_sym] = block
      end
    end
  end

  class Migration
    @@all = []

    class << self
      def all
        @@all
      end

      def add_for(engine)
        add_dirs engine.paths["db/migrate"].existent
      end

      def add_dirs(*dirs)
        @@all.push *dirs
        @@all.tap &:uniq!
      end
    end
  end

  # Ultimately this will have 3 sections to add from... the beggining,
  # middle or end.  However, this isn't needed until comics and pages
  # are pushed out to gems.
  class Routes
    @@all = []

    class << self
      def add(&block)
        @@all << block
      end

      def load!(instance)
        @@all.each do |routes|
          instance.instance_exec &routes
        end
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
