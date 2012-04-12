class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.datetime :posted_at
      t.datetime :expired_at
      t.string :title
      t.text :content, :null => false
      t.string :location
      t.boolean :enabled, :null => false, :default => false
      t.timestamps
    end

    add_index :announcements, [:posted_at, :expired_at, :enabled]
    add_index :announcements, [:expired_at, :enabled]
  end
end
