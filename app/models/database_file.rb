class DatabaseFile < ActiveRecord::Base
  attr_accessible :filename, :extension, :content

  def to_backup_entries
    if filename
      meta_name = "#{filename}.meta"
    else
      meta_name = "meta"
    end

    file = Backup::Entry.new id, filename, extension, content
    meta = Backup::Entry.new id, meta_name, "json", to_json(:except => :content)
    [file, meta]
  end

  class << self
    def sanitize(value)
      value.gsub(/\s+/, "_").gsub(/[^0-9a-zA-Z.\-_]/, "")
    end

    def create_from_param(file)
      original_filename = file.original_filename
      extension = File.extname original_filename
      filename = File.basename original_filename, extension
      filename = nil if filename.blank?

      if extension.blank?
        extension = nil
      else
        extension = extension[/^\.?(.*?)$/, 1]
      end

      create :filename => filename, :extension => extension, :content => file.read
    end
  end
end
