module CartoonistTwitter
  class Engine < ::Rails::Engine
    config.to_prepare do
      if Setting.table_exists?
        twitter_auth_changed = lambda do
          Twitter.configure do |twitter_config|
            twitter_config.consumer_key = Setting[:twitter_consumer_key]
            twitter_config.consumer_secret = Setting[:twitter_consumer_secret]
            twitter_config.oauth_token = Setting[:twitter_oauth_token]
            twitter_config.oauth_token_secret = Setting[:twitter_oauth_token_secret]
          end
        end

        Setting::Section.define :twitter, :order => 2, :tab => :social_and_analytics do
          Setting.define :twitter_enabled, :type => :boolean, :order => 1
          Setting.define :default_tweet, :order => 2
          Setting.define :twitter_handle, :order => 3
          Setting.define :twitter_consumer_key, :onchange => twitter_auth_changed, :order => 4
          Setting.define :twitter_consumer_secret, :onchange => twitter_auth_changed, :order => 5
          Setting.define :twitter_oauth_token, :onchange => twitter_auth_changed, :order => 6
          Setting.define :twitter_oauth_token_secret, :onchange => twitter_auth_changed, :order => 7
        end

        twitter_auth_changed.call
      end
    end

    Cartoonist::Navigation::Link.add :url => (lambda { "https://twitter.com/#{Setting[:twitter_handle]}" }), :class => "follow-us", :label => "cartoonist.layout.navigation.follow_on_twitter", :title => "cartoonist.layout.navigation.follow_on_twitter_title", :order => 2
  end
end
