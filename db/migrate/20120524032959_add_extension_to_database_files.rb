class AddExtensionToDatabaseFiles < ActiveRecord::Migration
  def change
    add_column :database_files, :extension, :string
    DatabaseFile.update_all :extension => "png"
  end
end
