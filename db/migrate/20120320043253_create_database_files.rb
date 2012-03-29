class CreateDatabaseFiles < ActiveRecord::Migration
  def change
    create_table :database_files do |t|
      t.string :filename
      t.binary :content, :null => false
      t.timestamps
    end
  end
end
