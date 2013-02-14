class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.integer :site_id, :null => false
      t.string :name
      t.text :description
      t.boolean :enabled, :null => false, :default => true
      t.boolean :admin_enabled, :null => false, :default => true
      t.timestamps
    end

    add_index :domains, [:name], :unique => true
    Domain.create! :site => Site.initial, :name => nil, :description => "Any domain not matched will route to this site."
  end
end
