class AddOmniautableToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :provider
      t.string :uid
    end

    add_index :users, [:provider, :uid], :unique => true
  end
end
