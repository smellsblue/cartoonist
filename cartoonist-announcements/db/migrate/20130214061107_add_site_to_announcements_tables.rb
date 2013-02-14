class AddSiteToAnnouncementsTables < ActiveRecord::Migration
  def up
    add_column :announcements, :site_id, :integer, :null => false, :default => Site.initial.id
  end

  def down
    remove_column :announcements, :site_id
  end
end
