class Tweet < ActiveRecord::Base
  def entity
    @entity ||= Cartoonist::Entity[entity_type.to_sym].model_class.find(entity_id)
  end

  class << self
    def styles(entity)
      results = []
      results << { :value => :disabled, :label => "tweet.style.disabled" }
      results << { :value => :manual, :label => "tweet.style.manual" }

      if Cartoonist::Entity[entity].model_class.include? Postable
        results << { :value => :automatic, :label => "tweet.style.automatic" }
        results << { :value => :automatic_timed, :label => "tweet.style.automatic_timed" }
      end

      results
    end
  end
end
