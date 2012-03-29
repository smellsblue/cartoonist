class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.string :title, :null => false
      t.string :url_title, :null => false
      t.string :author, :null => false
      t.datetime :posted_at
      t.text :content, :null => false
      t.string :tweet, :null => false, :length => 140
      t.datetime :tweeted_at
      t.boolean :locked, :null => false, :default => false
      t.timestamps
    end

    add_index :blog_posts, :title, :unique => true
    add_index :blog_posts, :url_title, :unique => true
    add_index :blog_posts, :posted_at
  end
end
