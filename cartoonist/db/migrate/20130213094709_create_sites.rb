class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name, :null => false
      t.text :description
      t.boolean :enabled, :null => false, :default => true
      t.timestamps
    end

    add_index :sites, [:name], :unique => true
    Site.create! :name => "default", :description => "The initial site."
  end
end
