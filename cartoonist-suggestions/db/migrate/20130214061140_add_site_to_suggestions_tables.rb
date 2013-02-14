class AddSiteToSuggestionsTables < ActiveRecord::Migration
  def change
    add_column :suggestions, :site_id, :integer, :null => false, :default => Site.initial.id
  end
end
