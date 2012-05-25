class Tag < ActiveRecord::Base
  has_many :entity_tags
  attr_accessible :label
end
