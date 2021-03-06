module CartoonistTwitter
  class EntityHooks
    class << self
      def after_entity_save(entity)
        return if entity.site.settings[:"#{entity.entity_type}_tweet_style"] == :disabled
        result = Tweet.find_for entity
        Tweet.create_for entity unless result
      end

      def edit_entity_before_partial
        "admin/tweets/entity_tweet"
      end
    end
  end

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
          Setting.define :"#{entity.entity_type}_tweet_style", :type => :symbol, :order => (order += 1), :label => lambda { I18n.t("settings.show.settings.tweet_style", :entity => entity.entity_localized_label) }, :select_from => lambda { Tweet.styles(entity.entity_type) }, :default => :disabled
          Setting.define :"#{entity.entity_type}_tweet_time", :order => (order += 1), :label => lambda { I18n.t("settings.show.settings.tweet_time", :entity => entity.entity_localized_label) }, :info_label => "settings.show.settings.tweet_time_info", :validation => lambda { |value| raise Setting::InvalidError.new I18n.t("settings.show.errors.invalid_tweet_time", :value => value) unless value =~ /^((1[0-2]|[1-9])\:[0-5]\d (am|pm|AM|PM))?$/ }
          Setting.define :"#{entity.entity_type}_default_tweet", :order => (order += 1), :label => lambda { I18n.t("settings.show.settings.default_tweet", :entity => entity.entity_localized_label) }
        end

        Setting.define :twitter_handle, :order => (order += 1)
        Setting.define :twitter_consumer_key, :onchange => twitter_auth_changed, :order => (order += 1)
        Setting.define :twitter_consumer_secret, :onchange => twitter_auth_changed, :order => (order += 1)
        Setting.define :twitter_oauth_token, :onchange => twitter_auth_changed, :order => (order += 1)
        Setting.define :twitter_oauth_token_secret, :onchange => twitter_auth_changed, :order => (order += 1)
      end

      if Setting.table_exists?
        twitter_auth_changed.call
      end
    end

    Cartoonist::Admin::Tab.add :tweets, :url => "/admin/tweets"
    Cartoonist::Navigation::Link.add :url => (lambda { "https://twitter.com/#{Setting[:twitter_handle]}" }), :class => "follow-us", :label => "cartoonist.layout.navigation.follow_on_twitter", :title => "cartoonist.layout.navigation.follow_on_twitter_title", :order => 2
    Cartoonist::Migration.add_for self
    Cartoonist::Entity.register_hooks CartoonistTwitter::EntityHooks

    Cartoonist::Backup.for :tweets do
      Tweet.order(:id)
    end

    Cartoonist::Cron.add do
      Tweet.untweeted.each do |tweet|
        tweet.auto_tweet!
      end
    end

    Cartoonist::Routes.add do
      namespace :admin do
        resources :tweets, :only => [:create, :edit, :index, :update]
      end
    end
  end
end
