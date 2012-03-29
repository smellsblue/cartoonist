class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title, :null => false
      t.string :path, :null => false
      t.date :posted_at
      t.text :content, :null => false
      t.boolean :locked, :null => false, :default => false
      t.boolean :comments, :null => false, :default => false
      t.boolean :in_sitemap, :null => false, :default => false
      t.timestamps
    end

    add_index :pages, :title, :unique => true
    add_index :pages, :path, :unique => true
  end
end
