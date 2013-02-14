class AddSiteToComicsTables < ActiveRecord::Migration
  def up
    add_column :comics, :site_id, :integer, :null => false, :default => Site.initial.id
    remove_index :comics, :number, :unique => true
    add_index :comics, [:number, :site_id], :unique => true
  end

  def down
    remove_index :comics, [:number, :site_id], :unique => true
    add_index :comics, :number, :unique => true
    remove_column :comics, :site_id
  end
end
