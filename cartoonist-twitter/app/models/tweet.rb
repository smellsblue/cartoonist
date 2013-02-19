class Tweet < ActiveRecord::Base
  include BelongsToEntity
  validate :doesnt_update_tweet_after_tweeted
  validate :entity_doesnt_change, :on => :update
  attr_accessible :entity_id, :entity_type, :tweet, :tweeted_at
  belongs_to :site

  def allow_tweet_now?
    allow_save? && !disabled? && entity_posted?
  end

  def allow_resend_tweet?
    tweeted? && !disabled? && entity_posted?
  end

  def entity_posted?
    if entity.kind_of? Postable
      posted = entity.posted?
    else
      posted = true
    end
  end

  def allow_save?
    !tweeted?
  end

  def disabled?
    tweet_style == :disabled
  end

  def formatted_tweeted_at(default_msg = "not yet tweeted")
    return default_msg unless tweeted_at
    tweeted_at.localtime.strftime "%-m/%-d/%Y at %-l:%M %P"
  end

  def manual_tweet!
    raise "Tweeting is not allowed!" unless allow_tweet_now?
    return if tweeted?
    return if disabled?
    send_tweet!
  end

  def resend_tweet!
    raise "Tweeting is not allowed!" unless allow_resend_tweet?
    return unless tweeted?
    return if disabled?
    send_tweet!
  end

  def auto_tweet!
    return if tweeted?
    return unless expected_tweet_time
    return unless Time.now >= expected_tweet_time
    send_tweet!
  end

  def tweet_style
    site.settings[:"#{entity.entity_type}_tweet_style"]
  end

  def tweet_time
    site.settings[:"#{entity.entity_type}_tweet_time"]
  end

  def form_path
    if new_record?
      "/admin/tweets"
    else
      "/admin/tweets/#{id}"
    end
  end

  def form_method
    if new_record?
      :post
    else
      :put
    end
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

  rescue => e
    logger.error "Error while sending tweet, will mark sent anyways (just in case):
#{e.class} (#{e.message})
    #{e.backtrace.join "\n    "}

"
  ensure
    self.tweeted_at = Time.now
    save!
  end

  def doesnt_update_tweet_after_tweeted
    if !tweeted_at_was.nil? && tweet_changed?
      errors.add :tweet, "can't change after the tweet has been sent"
    end
  end

  class << self
    def update_tweet(params)
      tweet = find params[:id].to_i
      return tweet if params[:resend_tweet].present?
      raise "Saving is not allowed!" unless tweet.allow_save?
      tweet.tweet = params[:tweet]
      tweet.save!
      tweet
    end

    def create_tweet(params)
      raise "The entity_id is required!" if params[:entity_id].blank?
      raise "The entity_type is required!" if params[:entity_type].blank?
      create :entity_id => params[:entity_id].to_i, :entity_type => params[:entity_type], :tweet => params[:tweet]
    end

    def tweet_for(entity)
      result = find_for entity

      if result
        result
      else
        new options_for(entity)
      end
    end

    def create_for(entity)
      create options_for(entity)
    end

    def options_for(entity)
      { :entity_id => entity.id, :entity_type => entity.entity_type, :tweet => SimpleTemplate[entity.site.settings[:"#{entity.entity_type}_default_tweet"], :self => entity] }
    end

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

    def not_disabled
      result = all

      types = result.map(&:entity_type).uniq.select do |t|
        t.site.settings[:"#{t}_tweet_style"] != :disabled
      end

      result.select { |x| types.include? x.entity_type }
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
