def system_exec(cmd)
  puts %x[#{cmd}]
end

class CartoonistGem
  def initialize(gemname)
    @dir = gemname
    @gemname = gemname
  end

  def generate
    puts "Generating files for #{@gemname}"
    path = File.join File.dirname(__FILE__), @dir, "lib/#{@dir}/version.rb"
    class_name = @gemname.gsub(/^\w|-\w/) { |x| x.sub("-", "").upcase }
    File.write path, %{module #{class_name}
  class Version
    class << self
      def to_s
        "#{CartoonistGem.version}"
      end
    end
  end
end
}
  end

  def build
    puts "Building #{@gemname}"
    system_exec "#{cd} && gem build #{gemspec}"
  end

  def install
    puts "Installing #{@gemname}"
    system_exec "#{cd} && gem install --no-ri --no-rdoc #{gem}"
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

CARTOONIST_GEMS = [CartoonistGem.new("cartoonist"),
                   CartoonistGem.new("cartoonist-announcements"),
                   CartoonistGem.new("cartoonist-blog"),
                   CartoonistGem.new("cartoonist-comics"),
                   CartoonistGem.new("cartoonist-default-theme"),
                   CartoonistGem.new("cartoonist-pages"),
                   CartoonistGem.new("cartoonist-tags"),
                   CartoonistGem.new("cartoonist-twitter")]

task :default => :build

task :generate do
  CARTOONIST_GEMS.each &:generate
end

task :build => :generate do
  CARTOONIST_GEMS.each &:build
end

task :install => :build do
  CARTOONIST_GEMS.each &:install
end

task :tag do
  puts "Tagging cartoonist"
  system_exec "git tag -a #{CartoonistGem.version} -m 'Version #{CartoonistGem.version}' && git push --tags"
end

task :push => :build do
  CARTOONIST_GEMS.each &:push
end
