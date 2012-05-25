module CartoonistTags
  class EntityHooks
    class << self
      def edit_entity_before_partial
        "admin/tags/entity_tags"
      end

      def show_entity_before_partial
        "tags/entity_tags"
      end
    end
  end

  class Engine < ::Rails::Engine
    Cartoonist::Migration.add_for self
    Cartoonist::Entity.register_hooks CartoonistTags::EntityHooks

    Cartoonist::Backup.for :tags do
      Tag.order(:id)
    end

    Cartoonist::Backup.for :entity_tags do
      EntityTag.order(:id)
    end

    Cartoonist::Routes.add do
      resources :tags

      namespace :admin do
        resources :tags
      end
    end
  end
end
