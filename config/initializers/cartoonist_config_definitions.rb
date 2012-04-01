CartoonistConfig.define :domain
CartoonistConfig.define :site_name
CartoonistConfig.define :site_heading
CartoonistConfig.define :site_update_description
CartoonistConfig.define :theme, :type => :symbol
CartoonistConfig.define :schedule, :type => :array, :default => [:monday, :wednesday, :friday]
CartoonistConfig.define :copyright_starting_year, :type => :int
CartoonistConfig.define :copyright_owners
CartoonistConfig.define :default_title
CartoonistConfig.define :default_tweet
CartoonistConfig.define :twitter_enabled, :type => :boolean
CartoonistConfig.define :twitter_handle
CartoonistConfig.define :twitter_consumer_key
CartoonistConfig.define :twitter_consumer_secret
CartoonistConfig.define :twitter_oath_token
CartoonistConfig.define :twitter_oath_token_secret
CartoonistConfig.define :google_analytics_enabled, :type => :boolean
CartoonistConfig.define :google_analytics_account
CartoonistConfig.define :disqus_enabled, :type => :boolean
CartoonistConfig.define :disqus_shortname
CartoonistConfig.define :disqus_comic_category
CartoonistConfig.define :disqus_blog_post_category
CartoonistConfig.define :disqus_page_category
CartoonistConfig.define :admin_users, :type => :hash
CartoonistConfig.define :secret_token

Twitter.configure do |config|
  config.consumer_key = CartoonistConfig[:twitter_consumer_key]
  config.consumer_secret = CartoonistConfig[:twitter_consumer_secret]
  config.oauth_token = CartoonistConfig[:twitter_oath_token]
  config.oauth_token_secret = CartoonistConfig[:twitter_oath_token_secret]
end

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Cartoonist::Application.config.secret_token = CartoonistConfig[:secret_token]
