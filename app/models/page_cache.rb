class PageCache
  attr_reader :name

  CACHE_PATH = File.join Rails.root, "public/cache"

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

  def www?
    return @www_exists unless @www_exists.nil?
    @www_exists = File.exists? File.join(CACHE_PATH, "#{name}.www.html")
  end

  def www_tmp?
    return @www_tmp_exists unless @www_tmp_exists.nil?
    @www_tmp_exists = File.exists? File.join(CACHE_PATH, "#{name}.www.tmp.html")
  end

  def m?
    return @m_exists unless @m_exists.nil?
    @m_exists = File.exists? File.join(CACHE_PATH, "#{name}.m.html")
  end

  def m_tmp?
    return @m_tmp_exists unless @m_tmp_exists.nil?
    @m_tmp_exists = File.exists? File.join(CACHE_PATH, "#{name}.m.tmp.html")
  end

  def expire!
    PageCache.cache_files(:with_gz => true).select do |file|
      extracted_name = file.sub /\.(?:www|m)(?:\.tmp)?\.html(?:.gz)?$/, ""
      extracted_name == name
    end.each do |file|
      File.delete File.join(CACHE_PATH, file)
    end
  end

  class << self
    def find(name)
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
      globber = "**/*.html"
      globber += "*" if options[:with_gz]

      Dir.glob(File.join(CACHE_PATH, globber), File::FNM_DOTMATCH).map do |file|
        file.sub "#{CACHE_PATH}/", ""
      end
    end

    def cache_names
      cache_files.map do |file|
        file.sub /\.(?:www|m)(?:\.tmp)?\.html$/, ""
      end.sort.uniq
    end

    def expire_www!
      File.delete *Dir.glob(File.join(CACHE_PATH, "**/*.www.html*"), File::FNM_DOTMATCH)
      File.delete *Dir.glob(File.join(CACHE_PATH, "**/*.www.tmp.html*"), File::FNM_DOTMATCH)
    end

    def expire_m!
      File.delete *Dir.glob(File.join(CACHE_PATH, "**/*.m.html*"), File::FNM_DOTMATCH)
      File.delete *Dir.glob(File.join(CACHE_PATH, "**/*.m.tmp.html*"), File::FNM_DOTMATCH)
    end

    def expire_tmp!
      File.delete *Dir.glob(File.join(CACHE_PATH, "**/*.tmp.html*"), File::FNM_DOTMATCH)
    end

    def expire_all!
      File.delete *Dir.glob(File.join(CACHE_PATH, "**/*.html*"), File::FNM_DOTMATCH)
    end
  end
end
