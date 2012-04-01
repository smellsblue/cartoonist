if Setting.table_exists?
  Setting.define :domain
  Setting.define :site_name
  Setting.define :site_heading
  Setting.define :site_update_description
  Setting.define :theme, :type => :symbol
  Setting.define :schedule, :type => :array, :default => [:monday, :wednesday, :friday]
  Setting.define :copyright_starting_year, :type => :int
  Setting.define :copyright_owners
  Setting.define :default_title
  Setting.define :default_tweet
  Setting.define :twitter_enabled, :type => :boolean
  Setting.define :twitter_handle
  Setting.define :twitter_consumer_key
  Setting.define :twitter_consumer_secret
  Setting.define :twitter_oath_token
  Setting.define :twitter_oath_token_secret
  Setting.define :google_analytics_enabled, :type => :boolean
  Setting.define :google_analytics_account
  Setting.define :disqus_enabled, :type => :boolean
  Setting.define :disqus_shortname
  Setting.define :disqus_comic_category
  Setting.define :disqus_blog_post_category
  Setting.define :disqus_page_category
  Setting.define :admin_users, :type => :hash
  Setting.define :secret_token

  Twitter.configure do |config|
    config.consumer_key = Setting[:twitter_consumer_key]
    config.consumer_secret = Setting[:twitter_consumer_secret]
    config.oauth_token = Setting[:twitter_oath_token]
    config.oauth_token_secret = Setting[:twitter_oath_token_secret]
  end

  # Your secret key for verifying the integrity of signed cookies.
  # If you change this key, all old signed cookies will become invalid!
  # Make sure the secret is at least 30 characters and all random,
  # no regular words or you'll be exposed to dictionary attacks.
  Cartoonist::Application.config.secret_token = Setting[:secret_token]
end
