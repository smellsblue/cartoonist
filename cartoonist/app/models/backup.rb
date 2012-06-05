class Backup
  ALLOWED_EXTENSIONS = [:tgz, :zip]

  def initialize(extension)
    raise "Invalid extension '#{extension}'" unless ALLOWED_EXTENSIONS.include? extension.to_sym
    @extension = extension.to_sym
  end

  def content_disposition
    %{attachment; filename="#{filename}"}
  end

  def filename
    prefix = "dev-" unless Rails.env.production?
    "#{prefix}cartoonist-backup-#{Time.now.strftime("%Y-%m-%d_%H%M%S")}.#{@extension}"
  end

  def response_body
    Enumerator.new do |out|
      send @extension, out
    end
  end

  def zip(out)
    buffer = Zip::ZipOutputStream.write_buffer do |zos|
      Backup.each do |entry|
        zos.put_next_entry entry.path
        zos.write entry.content
      end
    end

    out << buffer.string
  end

  def tgz(out)
    gzip = Zlib::GzipWriter.new Backup::ResponseOutWriter.new(out)

    begin
      Archive::Tar::Minitar::Writer.open gzip do |tar|
        Backup.each do |entry|
          tar.add_file_simple entry.path, :mode => 0644, :size => entry.content.length do |output|
            output.write entry.content
          end
        end
      end
    ensure
      gzip.close
    end
  end

  class ResponseOutWriter < Struct.new(:stream)
    def write(content)
      stream << content
    end
  end

  class << self
    def each
      Cartoonist::Backup.all.each do |key, proc|
        proc.call.find_each do |value|
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

      title = DatabaseFile.sanitize title
      extension = DatabaseFile.sanitize(extension || "")
      extension = ".#{extension}" if extension.present?
      @filename = "#{title}#{extension}"
      @content = content
    end

    def with_key(key)
      @key = key
      self
    end

    def safe_key
      DatabaseFile.sanitize key.to_s
    end

    def path
      "#{safe_key}/#{filename}"
    end

    class << self
      def from_record(record)
        title = record.zip_title if record.respond_to? :zip_title
        new record.id, title, "json", record.to_json
      end
    end
  end
end
