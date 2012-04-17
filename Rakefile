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
    system_exec "#{cd} && gem build #{gemspec}"
  end

  def install
    puts "Installing #{@gemname}"
    system_exec "#{cd} && gem install #{gem}"
  end

  def tag
    puts "Tagging #{@gemname}"
    system_exec "#{cd} && git tag -a #{CartoonistGem.version} -m 'Version #{CartoonistGem.version}' && git push --tags"
  end

  def push
    puts "Pushing #{@gemname}"
    system_exec "#{cd} && gem push #{gem}"
  end

  class << self
    def version
      @@version ||= File.read(File.join(File.dirname(__FILE__), "CARTOONIST_VERSION")).strip
    end
  end

  private
  def cd
    "cd #{File.join File.dirname(__FILE__), @dir}"
  end

  def gemspec
    "#{@gemname}.gemspec"
  end

  def gem
    "#{@gemname}-#{CartoonistGem.version}.gem"
  end
end

class Cartoonist
  def tag
    puts "Tagging cartoonist"
    system_exec "#{cd} && git tag -a #{CartoonistGem.version} -m 'Version #{CartoonistGem.version}' && git push --tags"
  end

  private
  def cd
    "cd cartoonist"
  end
end

class CartoonistGems
  def tag
    puts "Tagging cartoonist-gems"
    system_exec "git tag -a #{CartoonistGem.version} -m 'Version #{CartoonistGem.version}' && git push --tags"
  end
end

CARTOONIST_GEMS = [CartoonistGem.new("cartoonist-announcements"),
                   CartoonistGem.new("cartoonist-blog"),
                   CartoonistGem.new("cartoonist-comics"),
                   CartoonistGem.new("cartoonist-core", "cartoonist"),
                   CartoonistGem.new("cartoonist-default-theme"),
                   CartoonistGem.new("cartoonist-pages")]
CARTOONIST_AND_GEMS = CARTOONIST_GEMS + [CartoonistGems.new, Cartoonist.new]

task :default => :build

task :build do
  CARTOONIST_GEMS.each &:build
end

task :install => :build do
  CARTOONIST_GEMS.each &:install
end

task :tag do
  CARTOONIST_AND_GEMS.each &:tag
end

task :push => :build do
  CARTOONIST_GEMS.each &:push
end
