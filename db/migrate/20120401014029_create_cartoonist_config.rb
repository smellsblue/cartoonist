class CreateCartoonistConfig < ActiveRecord::Migration
  def change
    create_table :cartoonist_configs do |t|
      t.string :label, :null => false
      t.text :value
      t.boolean :locked, :default => false, :null => false
      t.timestamps
    end

    add_index :cartoonist_configs, :label, :unique => true
  end
end
