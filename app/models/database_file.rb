class DatabaseFile < ActiveRecord::Base
  attr_accessible :filename, :content

  def to_backup_entries
    if filename
      meta_name = "#{filename}.meta"
    else
      meta_name = "meta"
    end

    file = Backup::Entry.new id, filename, "png", content
    meta = Backup::Entry.new id, meta_name, "json", to_json(:except => :content)
    [file, meta]
  end
end
