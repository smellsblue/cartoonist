class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.string :name
      t.string :email
      t.string :ip
      t.text :content, :null => false
      t.text :options
      t.boolean :hidden, :null => false, :default => false
      t.timestamps
    end
  end
end
