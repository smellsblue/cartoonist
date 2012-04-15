def system_exec(cmd)
  puts %x[#{cmd}]
end

class CartoonistGem
  def initialize(dir, gemname = nil)
    @dir = dir
    @gemname = gemname || dir
  end

  def build
    puts "Building #{@gemname}"
    system_exec "cd #{File.join File.dirname(__FILE__), @dir} && gem build #{@gemname}.gemspec"
  end

  def install
    puts "Installing #{@gemname}"
    system_exec "cd #{File.join File.dirname(__FILE__), @dir} && gem install #{@gemname}-#{CartoonistGem.version}.gem"
  end

  class << self
    def version
      @@version ||= File.read(File.join(File.dirname(__FILE__), "CARTOONIST_VERSION")).strip
    end
  end
end

CARTOONIST_GEMS = [CartoonistGem.new("cartoonist-announcements"),
                   CartoonistGem.new("cartoonist-blog"),
                   CartoonistGem.new("cartoonist-comics"),
                   CartoonistGem.new("cartoonist-core", "cartoonist"),
                   CartoonistGem.new("cartoonist-default-theme"),
                   CartoonistGem.new("cartoonist-pages")]

task :default => :build

task :build do
  CARTOONIST_GEMS.each &:build
end

task :install => :build do
  CARTOONIST_GEMS.each &:install
end
