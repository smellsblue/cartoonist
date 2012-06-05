class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :label, :null => false
      t.timestamps
    end

    add_index :tags, :label, :unique => true

    create_table :entity_tags do |t|
      t.integer :entity_id, :null => false
      t.string :entity_type, :null => false
      t.integer :tag_id, :null => false
      t.timestamps
    end

    add_index :entity_tags, [:entity_id, :entity_type, :tag_id], :unique => true
  end
end
