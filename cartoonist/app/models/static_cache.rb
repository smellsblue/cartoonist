class StaticCache
  attr_reader :name

  CACHE_PATH = File.join Rails.root, "public/cache/static"

  def initialize(name)
    @name = name
  end

  def expire!
    gz_name = "#{name}.gz"
    StaticCache.cache_files(:with_gz => true).select do |file|
      file == name || file == gz_name
    end.each do |file|
      File.delete File.join(CACHE_PATH, file)
    end
  end

  class << self
    def find(name)
      name = "" if name == "INDEX"
      actual = cache_files.select { |x| x == name }.first
      raise ActiveRecord::RecordNotFound.new("No records found!") unless actual
      StaticCache.new actual
    end

    def all
      cache_files.map do |name|
        StaticCache.new name
      end
    end

    def cache_files(options = {})
      Dir.glob(File.join(CACHE_PATH, "**/*"), File::FNM_DOTMATCH).map do |file|
        next if file =~ /\.gz$/ unless options[:with_gz]
        next if File.directory? file
        file.sub "#{CACHE_PATH}/", ""
      end.compact.sort.uniq
    end

    def expire_all!
      files = Dir.glob File.join(CACHE_PATH, "**/*"), File::FNM_DOTMATCH
      files.reject! { |file| File.directory? file }
      File.delete *files unless files.empty?
    end
  end
end
