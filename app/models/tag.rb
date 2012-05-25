class Tag < ActiveRecord::Base
  has_many :entity_tags
  attr_accessible :label

  class << self
    def existing
      order(:label).all
    end

    def with_label(label)
      tag = where(:label => label).first
      tag = create :label => label unless tag
      tag
    end
  end
end
