class AddSiteToTagsTables < ActiveRecord::Migration
  def up
    add_column :tags, :site_id, :integer, :null => false, :default => Site.initial.id
    add_column :entity_tags, :site_id, :integer, :null => false, :default => Site.initial.id
    remove_index :tags, :label, :unique => true
    remove_index :entity_tags, [:entity_id, :entity_type, :tag_id], :unique => true
    add_index :tags, [:label, :site_id], :unique => true
    add_index :entity_tags, [:entity_id, :entity_type, :tag_id, :site_id], :unique => true
  end

  def down
    remove_index :tags, [:label, :site_id], :unique => true
    remove_index :entity_tags, [:entity_id, :entity_type, :tag_id, :site_id], :unique => true
    add_index :tags, :label, :unique => true
    add_index :entity_tags, [:entity_id, :entity_type, :tag_id], :unique => true
    remove_column :tags, :site_id
    remove_column :entity_tags, :site_id
  end
end
