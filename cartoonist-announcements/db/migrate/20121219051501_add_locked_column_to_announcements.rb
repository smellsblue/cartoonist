class AddLockedColumnToAnnouncements < ActiveRecord::Migration
  def change
    change_table :announcements do |t|
      t.boolean :locked, :null => false, :default => false
    end
  end
end
