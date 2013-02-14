class AddSiteToSuggestionsTables < ActiveRecord::Migration
  def up
    add_column :suggestions, :site_id, :integer, :null => false, :default => Site.initial.id
  end

  def down
    remove_column :suggestions, :site_id
  end
end
