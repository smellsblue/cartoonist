class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :label, :null => false
      t.text :value
      t.boolean :locked, :default => false, :null => false
      t.timestamps
    end

    add_index :settings, :label, :unique => true
  end
end
