class Admin::TagsController < CartoonistController
  def create
    entity_tag = EntityTag.create_tag params
    redirect_to entity_tag.entity.entity_edit_url
  end

  def destroy
    entity_tag = EntityTag.tagged_entity params
    entity = entity_tag.entity
    entity_tag.untag!
    redirect_to entity.entity_edit_url
  end
end
