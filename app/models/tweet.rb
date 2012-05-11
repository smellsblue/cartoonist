class Tweet < ActiveRecord::Base
  validate :doesnt_update_tweet_after_tweeted
  validate :entity_doesnt_change, :on => :update
  attr_accessible :entity_id, :entity_type, :tweet, :tweeted_at

  def entity
    @entity ||= Cartoonist::Entity[entity_type.to_sym].find(entity_id)
  end

  def description
    "#{entity.entity_localized_label}: #{entity.entity_description}"
  end

  def formatted_tweeted_at(default_msg = "not yet tweeted")
    return default_msg unless tweeted_at
    tweeted_at.localtime.strftime "%-m/%-d/%Y at %-l:%M %P"
  end

  def manual_tweet!
    return if tweeted?
    return if tweet_style == :disabled
    send_tweet!
  end

  def auto_tweet!
    return if tweeted?
    return unless expected_tweet_time
    return unless Time.now >= expected_tweet_time
    send_tweet!
  end

  def tweet_style
    Setting[:"#{entity.entity_type}_tweet_style"]
  end

  def tweet_time
    Setting[:"#{entity.entity_type}_tweet_time"]
  end

  def expected_tweet_time
    case tweet_style
    when :disabled
      nil
    when :manual
      nil
    when :automatic
      entity.posted_at
    when :automatic_timed
      if tweet_time.blank?
        entity.posted_at
      elsif entity.posted_at
        parsed = DateTime.strptime("#{entity.posted_at.year}-#{entity.posted_at.month}-#{entity.posted_at.day} #{tweet_time.downcase}", "%Y-%m-%d %I:%M %p").to_time
        result = Time.local entity.posted_at.year, entity.posted_at.month, entity.posted_at.day, parsed.hour, parsed.min
        result = result + 1.day if result < entity.posted_at.to_time
        result
      end
    else
      raise "Invalid tweet style #{tweet_style}"
    end
  end

  def tweeted?
    tweeted_at.present?
  end

  private
  def send_tweet!
    if Rails.env.production?
      Twitter.update tweet
    else
      logger.info "Fake Tweet: #{tweet}"
    end

    self.tweeted_at = Time.now
    save!
  end

  def doesnt_update_tweet_after_tweeted
    if !tweeted_at_was.nil? && tweet_changed?
      errors.add :tweet, "can't change after the tweet has been sent"
    end
  end

  def entity_doesnt_change
    if entity_id_changed?
      errors.add :entity_id, "can't change"
    end

    if entity_type_changed?
      errors.add :entity_id, "can't change"
    end
  end

  class << self
    def find_for(entity)
      raise "Can only find tweets for entities!" unless entity.kind_of? Entity
      where({ :entity_id => entity.id, :entity_type => entity.entity_type }).first
    end

    def tweeted
      where "tweeted_at IS NOT NULL"
    end

    def untweeted
      where "tweeted_at IS NULL"
    end

    def chronological
      order "tweeted_at ASC"
    end

    def reverse_chronological
      order "tweeted_at DESC"
    end

    def created_chronological
      order "created_at ASC"
    end

    def created_reverse_chronological
      order "created_at DESC"
    end

    def create_for(entity)
      create :entity_id => entity.id, :entity_type => entity.entity_type, :tweet => SimpleTemplate[Setting[:"#{entity.entity_type}_default_tweet"], :self => entity]
    end

    def styles(entity)
      results = []
      results << { :value => :disabled, :label => "tweet.style.disabled" }
      results << { :value => :manual, :label => "tweet.style.manual" }

      if Cartoonist::Entity[entity].include? Postable
        results << { :value => :automatic, :label => "tweet.style.automatic" }
        results << { :value => :automatic_timed, :label => "tweet.style.automatic_timed" }
      end

      results
    end
  end
end
