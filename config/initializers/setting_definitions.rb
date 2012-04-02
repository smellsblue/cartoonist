Rails.application.config.to_prepare do
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

    Setting.define :domain
    Setting.define :site_name
    Setting.define :site_heading
    Setting.define :site_update_description
    Setting.define :theme, :type => :symbol
    Setting.define :schedule, :type => :array, :default => [:monday, :wednesday, :friday]
    Setting.define :copyright_starting_year, :type => :int
    Setting.define :copyright_owners
    Setting.define :default_title
    Setting.define :admin_users, :type => :hash

    Setting::Tab.define :social_and_analytics, :order => 1 do
      Setting::Section.define :google_analytics, :order => 1 do
        Setting.define :google_analytics_enabled, :type => :boolean
        Setting.define :google_analytics_account
      end

      Setting::Section.define :twitter, :order => 2 do
        Setting.define :twitter_enabled, :type => :boolean
        Setting.define :default_tweet
        Setting.define :twitter_handle
        Setting.define :twitter_consumer_key, :onchange => twitter_auth_changed
        Setting.define :twitter_consumer_secret, :onchange => twitter_auth_changed
        Setting.define :twitter_oauth_token, :onchange => twitter_auth_changed
        Setting.define :twitter_oauth_token_secret, :onchange => twitter_auth_changed
      end

      Setting::Section.define :disqus, :order => 3 do
        Setting.define :disqus_enabled, :type => :boolean
        Setting.define :disqus_shortname
        Setting.define :disqus_comic_category
        Setting.define :disqus_blog_post_category
        Setting.define :disqus_page_category
      end
    end

    Setting::Tab.define :advanced, :order => 2 do
      Setting.define :secret_token, :default => "ThisTokenMustBeRegenerated....", :onchange => secret_token_changed
    end

    secret_token_changed.call
    twitter_auth_changed.call
  end
end
