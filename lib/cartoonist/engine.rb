module Cartoonist
  class Engine < ::Rails::Engine
    config.before_initialize do
      # Add in various configuration from plugins
      Rails.application.config.assets.precompile += ["admin.css"]
      Rails.application.config.assets.precompile += Cartoonist::Asset.all
      Rails.application.config.paths["db/migrate"] += Cartoonist::Migration.all

      if File.directory? File.join(Rails.root, "public/errors")
        Rails.application.config.exceptions_app = ActionDispatch::PublicExceptions.new(File.join Rails.root, "public/errors")
      else
        Rails.application.config.exceptions_app = ActionDispatch::PublicExceptions.new(File.join File.dirname(__FILE__), "../../public/errors")
      end
    end

    config.to_prepare do
      if Setting.table_exists?
        secret_token_changed = lambda do
          # Your secret key for verifying the integrity of signed cookies.
          # If you change this key, all old signed cookies will become invalid!
          # Make sure the secret is at least 30 characters and all random,
          # no regular words or you'll be exposed to dictionary attacks.
          Cartoonist::Application.config.secret_token = Setting[:secret_token]
        end

        twitter_auth_changed = lambda do
          Twitter.configure do |config|
            config.consumer_key = Setting[:twitter_consumer_key]
            config.consumer_secret = Setting[:twitter_consumer_secret]
            config.oauth_token = Setting[:twitter_oauth_token]
            config.oauth_token_secret = Setting[:twitter_oauth_token_secret]
          end
        end

        Setting.define :domain, :order => 1
        Setting.define :site_name, :order => 2
        Setting.define :site_heading, :order => 3
        Setting.define :site_update_description, :order => 4
        Setting.define :root_path, :type => :symbol, :default => Cartoonist::RootPath.all.first, :order => 5, :select_from => lambda { Cartoonist::RootPath.all }, :onchange => lambda { Rails.application.reload_routes! }
        Setting.define :theme, :type => :symbol, :default => :cartoonist_default_theme, :order => 6, :select_from => lambda { Cartoonist::Theme.all }
        Setting.define :schedule, :type => :array, :default => [:monday, :wednesday, :friday], :order => 7
        Setting.define :copyright_starting_year, :type => :int, :order => 8
        Setting.define :copyright_owners, :order => 9
        Setting.define :default_title, :order => 10
        Setting.define :admin_users, :type => :hash, :order => 11

        Setting::Tab.define :social_and_analytics, :order => 1 do
          Setting::Section.define :google_analytics, :order => 1 do
            Setting.define :google_analytics_enabled, :type => :boolean, :order => 1
            Setting.define :google_analytics_account, :order => 2
          end

          Setting::Section.define :twitter, :order => 2 do
            Setting.define :twitter_enabled, :type => :boolean, :order => 1
            Setting.define :default_tweet, :order => 2
            Setting.define :twitter_handle, :order => 3
            Setting.define :twitter_consumer_key, :onchange => twitter_auth_changed, :order => 4
            Setting.define :twitter_consumer_secret, :onchange => twitter_auth_changed, :order => 5
            Setting.define :twitter_oauth_token, :onchange => twitter_auth_changed, :order => 6
            Setting.define :twitter_oauth_token_secret, :onchange => twitter_auth_changed, :order => 7
          end

          Setting::Section.define :disqus, :order => 3 do
            Setting.define :disqus_enabled, :type => :boolean, :order => 1
            Setting.define :disqus_shortname, :order => 2
            Setting.define :disqus_comic_category, :order => 3
            Setting.define :disqus_blog_post_category, :order => 4
            Setting.define :disqus_page_category, :order => 5
          end
        end

        Setting::Tab.define :advanced, :order => 2 do
          Setting.define :secret_token, :default => "ThisTokenMustBeRegenerated....", :onchange => secret_token_changed
        end

        secret_token_changed.call
        twitter_auth_changed.call
      end
    end

    Cartoonist::Admin::Tab.add :general, :url => "/admin", :order => 3
    Cartoonist::Navigation::Link.add :url => (lambda { "https://twitter.com/#{Setting[:twitter_handle]}" }), :class => "follow-us", :label => "application.layout.navigation.follow_on_twitter", :title => "application.layout.navigation.follow_on_twitter_title", :order => 2
    Cartoonist::Migration.add_for self

    Cartoonist::Backup.for :files do
      DatabaseFile.order(:id).all
    end

    Cartoonist::Backup.for :settings do
      Setting.order(:id).all
    end

    Cartoonist::Routes.add_begin do
      root :to => Cartoonist::RootPath.current
    end

    Cartoonist::Routes.add do
      match "favicon" => "site#favicon", :defaults => { :format => "ico" }
      match "sitemap" => "site#sitemap", :defaults => { :format => "xml" }
      match "robots" => "site#robots", :defaults => { :format => "text" }

      resources :cache do
        collection do
          post "expire_www"
          post "expire_m"
          post "expire_tmp"
          post "expire_all"
        end
      end

      resources :static_cache, :constraints => { :id => /.*/ } do
        collection do
          post "expire_all"
        end
      end

      resources :admin do
        collection do
          get "cache_cron"
          get "backup"
          get "logout"
          get "main"
          get "reload"
          get "sign_in"
          post "sign_in"
          get "tweet_cron"
        end
      end

      resources :settings do
        collection do
          get "initial_setup"
          post "save_initial_setup"
        end
      end
    end
  end
end
