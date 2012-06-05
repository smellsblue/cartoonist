module BelongsToEntity
  def entity
    @entity ||= Cartoonist::Entity[entity_type.to_sym].find(entity_id)
  end

  def description
    "#{entity.entity_localized_label}: #{entity.entity_description}"
  end

  private
  def entity_doesnt_change
    if entity_id_changed?
      errors.add :entity_id, "can't change"
    end

    if entity_type_changed?
      errors.add :entity_id, "can't change"
    end
  end
end
