class EntityTag < ActiveRecord::Base
  include BelongsToEntity
  belongs_to :tag
  validate :entity_doesnt_change, :on => :update
  attr_accessible :entity_id, :entity_type, :tag_id

  def entity_url(preview)
    if preview
      entity.entity_relative_preview_url
    else
      entity.entity_relative_url
    end
  end

  def posted_header
    if entity.kind_of?(Postable) && entity.posted_at
      "#{entity.posted_at.to_time.localtime.strftime "%m/%d/%Y"}:"
    end
  end

  def untag!
    destroy
    remaining = EntityTag.where(:tag_id => tag.id).count
    tag.destroy if remaining == 0
  end

  class << self
    def create_tag(params)
      tag = Tag.with_label params[:label]
      result = where(:tag_id => tag.id, :entity_id => params[:entity_id].to_i, :entity_type => params[:entity_type]).first
      result = create :tag_id => tag.id, :entity_id => params[:entity_id].to_i, :entity_type => params[:entity_type] unless result
      result
    end

    def tagged_entity(params)
      where(:tag_id => params[:id].to_i, :entity_id => params[:entity_id].to_i, :entity_type => params[:entity_type]).first
    end

    def tags_for(entity)
      tag_ids = where(:entity_id => entity.id, :entity_type => entity.entity_type).pluck(:tag_id)
      Tag.where(:id => tag_ids).order(:label).all
    end
  end
end
