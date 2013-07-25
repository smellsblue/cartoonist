class Tag < ActiveRecord::Base
  has_many :entity_tags

  def previewable_url(preview)
    if preview
      "/admin/tags/#{id}"
    else
      "/tags/#{id}"
    end
  end

  def shown_entity_tags(preview)
    @shown_entity_tags ||= entity_tags.to_a.select do |entity_tag|
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

    raise ActiveRecord::RecordNotFound.new("No records found!") if @shown_entity_tags.empty?
    @shown_entity_tags
  end

  class << self
    def existing
      order(:label).to_a
    end

    def with_label(label)
      tag = where(:label => label).first
      tag = create :label => label unless tag
      tag
    end
  end
end
