class AddSiteToTwitterTables < ActiveRecord::Migration
  def up
    add_column :tweets, :site_id, :integer, :null => false, :default => Site.initial.id
    remove_index :tweets, [:entity_id, :entity_type]
    add_index :tweets, [:entity_id, :entity_type, :site_id], :unique => true
  end

  def down
    remove_index :tweets, [:entity_id, :entity_type, :site_id]
    add_index :tweets, [:entity_id, :entity_type], :unique => true
    remove_column :tweets, :site_id
  end
end
