class EntityTag < ActiveRecord::Base
  include BelongsToEntity
  belongs_to :tag
  validate :entity_doesnt_change, :on => :update
  attr_accessible :entity_id, :entity_type, :tag_id
end
