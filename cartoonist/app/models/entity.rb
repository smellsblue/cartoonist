module Entity
  def entity_type
    self.class.entity_type
  end

  def entity_label
    self.class.entity_label
  end

  def entity_localized_label
    self.class.entity_localized_label
  end

  def entity_description
    self.class.entity_description.call self
  end

  def entity_relative_previewable_url(preview)
    if preview
      entity_relative_preview_url
    else
      entity_relative_url
    end
  end

  def entity_relative_preview_url
    if self.class.entity_preview_url
      self.class.entity_preview_url.call self
    else
      entity_relative_url
    end
  end

  def entity_relative_url
    self.class.entity_url.call self if self.class.entity_url
  end

  def entity_absolute_url
    "http://#{Setting[:domain]}#{entity_relative_url}" if entity_relative_url
  end

  def entity_edit_url
    self.class.entity_edit_url.call self if self.class.entity_edit_url
  end

  def search_url
    entity_relative_preview_url
  end

  def self.included(base)
    base.extend ClassMethods

    base.after_save do |entity|
      Cartoonist::Entity.hooks_with(:after_entity_save).each do |hook|
        hook.after_entity_save entity
      end
    end
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

    def entity_localized_label
      I18n.t entity_label
    end

    def entity_description(&block)
      if block
        @entity_description = block
      else
        @entity_description
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

    def entity_preview_url(&block)
      if block
        @entity_preview_url = block
      else
        @entity_preview_url
      end
    end

    def entity_edit_url(&block)
      if block
        @entity_edit_url = block
      else
        @entity_edit_url
      end
    end
  end

  class EntityTypeNotSpecifiedError < StandardError
  end
end
