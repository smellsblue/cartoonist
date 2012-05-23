class Backup
  class << self
    def each
      Cartoonist::Backup.all.each do |key, proc|
        proc.call.each do |value|
          if value.respond_to? :to_backup_entries
            value.to_backup_entries.each do |entry|
              yield entry.with_key(key)
            end
          else
            yield Backup::Entry.from_record(value).with_key(key)
          end
        end
      end
    end
  end

  class Entry
    attr_reader :key, :filename, :content

    def initialize(id, title, extension, content)
      if title
        title = "%05d_%s" % [id, title]
      else
        title = "%05d" % id
      end

      title = Backup::Entry.sanitize title
      extension = Backup::Entry.sanitize extension
      @filename = "#{title}.#{extension}"
      @content = content
    end

    def with_key(key)
      @key = key
      self
    end

    def safe_key
      Backup::Entry.sanitize key.to_s
    end

    def path
      "#{safe_key}/#{filename}"
    end

    class << self
      def sanitize(value)
        value.gsub(/\s+/, "_").gsub(/[^0-9a-zA-Z.\-_]/, "")
      end

      def from_record(record)
        title = record.zip_title if record.respond_to? :zip_title
        new record.id, title, "json", record.to_json
      end
    end
  end
end
