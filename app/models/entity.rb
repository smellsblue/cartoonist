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

  module ClassMethods
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
  end

  class EntityTypeNotSpecifiedError < StandardError
  end
end
