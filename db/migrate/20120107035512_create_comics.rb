class CreateComics < ActiveRecord::Migration
  def change
    create_table :comics do |t|
      t.integer :number, :null => false
      t.date :posted_at, :null => false
      t.string :title, :null => false
      t.text :description, :null => false
      t.text :scene_description, :null => false
      t.text :dialogue, :null => false
      t.text :title_text, :null => false
      t.integer :database_file_id, :null => false
      t.boolean :locked, :default => false, :null => false
      t.timestamps
    end

    add_index :comics, :number, :unique => true
    add_index :comics, :posted_at
  end
end
