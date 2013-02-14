class AddSiteToPagesTables < ActiveRecord::Migration
  def up
    add_column :pages, :site_id, :integer, :null => false, :default => Site.initial.id
    remove_index :pages, :title
    remove_index :pages, :path
    add_index :pages, [:title, :site_id], :unique => true
    add_index :pages, [:path, :site_id], :unique => true
  end

  def down
    remove_index :pages, [:title, :site_id]
    remove_index :pages, [:path, :site_id]
    add_index :pages, :title, :unique => true
    add_index :pages, :path, :unique => true
    remove_column :pages, :site_id
  end
end
