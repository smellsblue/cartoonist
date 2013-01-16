class PageCache
  attr_reader :name

  CACHE_PATH = File.join Rails.root, "public/cache"
  EXTENSIONS = ["html", "json"]

  def initialize(name)
    @name = name
  end

  def display_name
    if name == ""
      "INDEX"
    else
      name
    end
  end

  def delete_name
    if name == ""
      "INDEX"
    else
      name
    end
  end

  def www?
    return @www_exists unless @www_exists.nil?
    @www_exists = EXTENSIONS.any? do |extension|
      File.exists? File.join(CACHE_PATH, "#{name}.www.#{extension}")
    end
  end

  def www_tmp?
    return @www_tmp_exists unless @www_tmp_exists.nil?
    @www_tmp_exists = EXTENSIONS.any? do |extension|
      File.exists? File.join(CACHE_PATH, "#{name}.www.tmp.#{extension}")
    end
  end

  def expire!
    PageCache.cache_files(:with_gz => true).select do |file|
      extracted_name = file.sub /\.(?:www)(?:\.tmp)?\.(?:#{EXTENSIONS.join "|"})(?:.gz)?$/, ""
      extracted_name == name
    end.each do |file|
      File.delete File.join(CACHE_PATH, file)
    end
  end

  class << self
    def find(name)
      name = "" if name == "INDEX"
      actual = cache_names.select { |x| x == name }.first
      raise ActiveRecord::RecordNotFound.new("No records found!") unless actual
      PageCache.new actual
    end

    def all
      cache_names.map do |name|
        PageCache.new name
      end
    end

    def cache_files(options = {})
      globs = EXTENSIONS.map do |extension|
        globber = "**/*.#{extension}"
        globber += "*" if options[:with_gz]
        File.join CACHE_PATH, globber
      end

      Dir.glob(globs, File::FNM_DOTMATCH).map do |file|
        file.sub "#{CACHE_PATH}/", ""
      end
    end

    def cache_names
      cache_files.map do |file|
        file.sub /\.(?:www)(?:\.tmp)?\.(?:#{EXTENSIONS.join "|"})$/, ""
      end.sort.uniq
    end

    def expire_www!
      EXTENSIONS.each do |extension|
        File.delete *Dir.glob(File.join(CACHE_PATH, "**/*.www.#{extension}*"), File::FNM_DOTMATCH)
        File.delete *Dir.glob(File.join(CACHE_PATH, "**/*.www.tmp.#{extension}*"), File::FNM_DOTMATCH)
      end
    end

    def expire_tmp!
      EXTENSIONS.each do |extension|
        File.delete *Dir.glob(File.join(CACHE_PATH, "**/*.tmp.#{extension}*"), File::FNM_DOTMATCH)
      end
    end

    def expire_all!
      EXTENSIONS.each do |extension|
        File.delete *Dir.glob(File.join(CACHE_PATH, "**/*.#{extension}*"), File::FNM_DOTMATCH)
      end
    end
  end
end
