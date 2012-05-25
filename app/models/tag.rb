class Tag < ActiveRecord::Base
  has_many :entity_tags
  attr_accessible :label

  def shown_entity_tags(preview)
    @shown_entity_tags ||= entity_tags.all.select do |entity_tag|
      preview || !entity_tag.entity.kind_of?(Postable) || entity_tag.entity.posted?
    end.sort do |a, b|
      if a.entity.kind_of?(Postable) && a.entity.posted_at && b.entity.kind_of?(Postable) && b.entity.posted_at
        b.entity.posted_at.to_date <=> a.entity.posted_at.to_date
      elsif a.entity.kind_of?(Postable) && a.entity.posted_at
        1
      elsif b.entity.kind_of?(Postable) && b.entity.posted_at
        -1
      else
        a.description <=> b.description
      end
    end
  end

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
