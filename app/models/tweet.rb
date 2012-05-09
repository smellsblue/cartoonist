class Tweet < ActiveRecord::Base
  def entity
    @entity ||= Cartoonist::Entity[entity_type.to_sym].find(entity_id)
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
