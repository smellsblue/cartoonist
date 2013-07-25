class DatabaseFile < ActiveRecord::Base
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

    def create_from_param(file, options = {})
      original_filename = file.original_filename
      extension = File.extname original_filename
      filename = File.basename original_filename, extension
      filename = nil if filename.blank?
      extension = extension[/^\.?(.*?)$/, 1].downcase if extension
      extension = nil if extension.blank?

      if options.include?(:allowed_extensions) && !options[:allowed_extensions].map(&:downcase).include?(extension)
        raise "Extension must be one of: #{options[:allowed_extensions].join ", "}"
      end

      create :filename => filename, :extension => extension, :content => file.read
    end
  end
end
