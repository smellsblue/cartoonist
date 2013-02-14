class AddSiteToBlogTables < ActiveRecord::Migration
  def up
    add_column :blog_posts, :site_id, :integer, :null => false, :default => Site.initial.id
    remove_index :blog_posts, :title, :unique => true
    remove_index :blog_posts, :url_title, :unique => true
    add_index :blog_posts, [:title, :site_id], :unique => true
    add_index :blog_posts, [:url_title, :site_id], :unique => true
  end

  def down
    remove_index :blog_posts, [:title, :site_id], :unique => true
    remove_index :blog_posts, [:url_title, :site_id], :unique => true
    add_index :blog_posts, :title, :unique => true
    add_index :blog_posts, :url_title, :unique => true
    remove_column :blog_posts, :site_id
  end
end
