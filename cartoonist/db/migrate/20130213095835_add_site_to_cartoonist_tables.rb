class AddSiteToCartoonistTables < ActiveRecord::Migration
  def up
    add_column :database_files, :site_id, :integer, :null => false, :default => Site.initial.id
    add_column :settings, :site_id, :integer, :null => false, :default => Site.initial.id
    remove_index :settings, :label, :unique => true
    add_index :settings, [:label, :site_id], :unique => true
  end

  def down
    remove_index :settings, [:label, :site_id], :unique => true
    add_index :settings, :label, :unique => true
    remove_column :settings, :site_id
    remove_column :database_files, :site_id
  end
end
