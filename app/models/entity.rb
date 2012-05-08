module Entity
  def entity_type
    self.class.entity_type
  end

  def entity_label
    self.class.entity_label
  end

  def self.included(base)
    base.extend ClassMethods
  end

  def entity_relative_url
    self.class.entity_url.call self if self.class.entity_url
  end

  def entity_absolute_url
    "http://#{Setting[:domain]}#{entity_relative_url}" if entity_relative_url
  end

  module ClassMethods
    def entity_relative_url
      entity_global_url
    end

    def entity_absolute_url
      "http://#{Setting[:domain]}#{entity_relative_url}" if entity_relative_url
    end

    def entity_type(value = nil)
      if value
        @entity_type = value
      else
        @entity_type || raise(EntityTypeNotSpecifiedError.new("entity_type was not defined for #{self.name}"))
      end
    end

    def entity_label(value = nil)
      if value
        @entity_label = value
      else
        @entity_label || "cartoonist.entity.#{entity_type}"
      end
    end

    def entity_global_url(value = nil)
      if value
        @entity_global_url = value
      else
        @entity_global_url
      end
    end

    def entity_url(&block)
      if block
        @entity_url = block
      else
        @entity_url
      end
    end
  end

  class EntityTypeNotSpecifiedError < StandardError
  end
end
