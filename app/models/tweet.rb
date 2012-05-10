class Tweet < ActiveRecord::Base
  validate :doesnt_update_tweet_after_tweeted
  validate :entity_doesnt_change, :on => :update

  def entity
    @entity ||= Cartoonist::Entity[entity_type.to_sym].find(entity_id)
  end

  private
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

    def after_entity_save(entity)
      return if Setting[:"#{entity.entity_type}_tweet_style"] == :disabled
      result = find_for entity
      create_for entity unless result
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
