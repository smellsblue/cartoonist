module CartoonistTwitter
  class Engine < ::Rails::Engine
    config.to_prepare do
      twitter_auth_changed = lambda do
        Twitter.configure do |twitter_config|
          twitter_config.consumer_key = Setting[:twitter_consumer_key]
          twitter_config.consumer_secret = Setting[:twitter_consumer_secret]
          twitter_config.oauth_token = Setting[:twitter_oauth_token]
          twitter_config.oauth_token_secret = Setting[:twitter_oauth_token_secret]
        end
      end

      Setting::Section.define :twitter, :order => 2, :tab => :social_and_analytics do
        order = 0

        Cartoonist::Entity.all.each do |entity|
          Setting.define :"#{entity}_tweet_style", :type => :symbol, :order => (order += 1), :label => lambda { I18n.t("settings.show.settings.tweet_style", :entity => I18n.t(Cartoonist::Entity[entity].label)) }, :select_from => lambda { Tweet.styles(entity) }, :default => :disabled
          Setting.define :"#{entity}_tweet_time", :order => (order += 1), :label => lambda { I18n.t("settings.show.settings.tweet_time", :entity => I18n.t(Cartoonist::Entity[entity].label)) }, :info_label => "settings.show.settings.tweet_time_info", :validation => lambda { |value| raise Setting::InvalidError.new I18n.t("settings.show.errors.invalid_tweet_time", :value => value) unless value =~ /^((1[0-2]|[1-9])\:[0-5]\d (am|pm|AM|PM))?$/ }
          Setting.define :"#{entity}_default_tweet", :order => (order += 1), :label => lambda { I18n.t("settings.show.settings.default_tweet", :entity => I18n.t(Cartoonist::Entity[entity].label)) }
        end

        Setting.define :twitter_handle, :order => (order += 1)
        Setting.define :twitter_consumer_key, :onchange => twitter_auth_changed, :order => (order += 1)
        Setting.define :twitter_consumer_secret, :onchange => twitter_auth_changed, :order => (order += 1)
        Setting.define :twitter_oauth_token, :onchange => twitter_auth_changed, :order => (order += 1)
        Setting.define :twitter_oauth_token_secret, :onchange => twitter_auth_changed, :order => (order += 1)
      end

      twitter_auth_changed.call
    end

    Cartoonist::Navigation::Link.add :url => (lambda { "https://twitter.com/#{Setting[:twitter_handle]}" }), :class => "follow-us", :label => "cartoonist.layout.navigation.follow_on_twitter", :title => "cartoonist.layout.navigation.follow_on_twitter_title", :order => 2

    Cartoonist::Cron.add do
      Comic.untweeted.each do |comic|
        comic.tweet!
        Rails.logger.info "Comic Tweet: #{comic.tweet}" unless Rails.env.production?
      end

      BlogPost.untweeted.each do |post|
        post.tweet!
        Rails.logger.info "Blog Post Tweet: #{post.tweet}" unless Rails.env.production?
      end
    end
  end
end
