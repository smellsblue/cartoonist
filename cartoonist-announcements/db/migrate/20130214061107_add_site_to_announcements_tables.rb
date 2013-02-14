class AddSiteToAnnouncementsTables < ActiveRecord::Migration
  def change
    add_column :announcements, :site_id, :integer, :null => false, :default => Site.initial.id
  end
end
