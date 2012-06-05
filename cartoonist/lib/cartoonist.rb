require "devise"
require "jquery-rails"
require "redcarpet"
require "zlib"
require "archive/tar/minitar"
require "zip/zip"

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
      # cartoonist.js.  This is purely standalone assets.
      def all
        @@all
      end

      # Include the following js files into cartoonist.js.
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

  class Cron
    @@all = []

    class << self
      def all
        @@all
      end

      def add(&block)
        @@all << block
      end
    end
  end

  class Entity
    @@all = {}
    @@cached_order = []
    @@hooks = []

    class << self
      def all
        @@cached_order.map &:constantize
      end

      def [](key)
        @@all[key].constantize
      end

      def add(key, model_name)
        @@all[key] = model_name
        @@cached_order = @@all.keys.sort.map { |key| @@all[key] }
      end

      def register_hooks(hooks)
        @@hooks << hooks unless @@hooks.include? hooks
      end

      def hooks
        @@hooks
      end

      def hooks_with(method)
        @@hooks.select { |x| x.respond_to? method }
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

  class Navigation
    class Link
      attr_reader :preview_url, :class, :label, :title, :order

      @@all = []
      @@cached_order = []

      def initialize(options)
        @url = options[:url]
        @preview_url = options[:preview_url]
        @class = options[:class]
        @label = options[:label]
        @title = options[:title]
        @order = options[:order]
      end

      def url(preview = false)
        if preview && @preview_url
          result = @preview_url
        else
          result = @url
        end

        if result.kind_of? Proc
          result.call
        else
          result
        end
      end

      class << self
        def all
          @@cached_order
        end

        def add(options)
          @@all << Cartoonist::Navigation::Link.new(options)
          @@cached_order = @@all.sort { |x, y| x.order <=> y.order }
        end
      end
    end
  end

  class RootPath
    @@all = []
    @@paths = {}

    class << self
      def all
        @@all
      end

      def add(path_name, path)
        (@@all << path_name.to_sym).sort! unless @@all.include? path_name.to_sym
        @@paths[path_name.to_sym] = path unless @@paths.include? path_name.to_sym
      end

      def [](key)
        @@paths[key.to_sym]
      end

      def current_key
        Setting[:root_path]
      end

      def current
        self[current_key]
      end
    end
  end

  class Routes
    @@begin = []
    @@middle = []
    @@end = []

    class << self
      def add_begin(&block)
        @@begin << block
      end

      def add(&block)
        @@middle << block
      end

      def add_end(&block)
        @@end << block
      end

      def load!(instance)
        @@begin.each do |routes|
          instance.instance_exec &routes
        end

        @@middle.each do |routes|
          instance.instance_exec &routes
        end

        @@end.each do |routes|
          instance.instance_exec &routes
        end
      end
    end
  end

  class Sitemap
    @@all = []

    class << self
      def all
        @@all.map(&:call).flatten
      end

      def add(&block)
        @@all << block
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

  require "cartoonist/engine"
end
