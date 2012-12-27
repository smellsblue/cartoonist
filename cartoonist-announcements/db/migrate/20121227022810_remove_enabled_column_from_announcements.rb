class RemoveEnabledColumnFromAnnouncements < ActiveRecord::Migration
  def change
    remove_index :announcements, [:posted_at, :expired_at, :enabled]
    remove_index :announcements, [:expired_at, :enabled]
    remove_column :announcements, :enabled
    add_index :announcements, [:posted_at, :expired_at]
    add_index :announcements, [:expired_at]
  end
end
