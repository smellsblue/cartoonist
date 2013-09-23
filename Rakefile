def system_exec(cmd)
  puts %x[#{cmd}]
end

class CartoonistGem
  def initialize(gemname)
    @dir = gemname
    @gemname = gemname
  end

  def check_dependencies
    puts "Checking dependencies for #{@gemname}"
    gemspec_file = File.join root_dir, gemspec
    contents = File.read gemspec_file

    contents.scan(/^.*dependency.*$/).each do |line|
      next unless line =~ /dependency.*\"(.*?)\".*\"(.*?)\".*/
      dep_gem = Regexp.last_match[1]
      dep_version = Regexp.last_match[2]
      dep_spec = Gem::Specification.find_by_name dep_gem, dep_version
      fetched = Gem::SpecFetcher.fetcher.search_for_dependency Gem::Dependency.new(dep_gem)
      fetched_version = fetched.first.first.first.version
      puts "  Requirement: #{dep_gem}: #{dep_version}"
      puts "    #{dep_spec.version} (latest: #{fetched_version})"
    end
  end

  def generate
    puts "Generating files for #{@gemname}"

    # Generate version.rb
    path = File.join root_dir, "lib/#{@dir}/version.rb"
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
    # Generate gemspec
    path = File.join root_dir, gemspec
    contents = File.read path

    new_contents = contents.gsub /(dependency.*\")(.*?)(\".*\")(.*?)(\".*)/ do |match|
      Regexp.last_match[1] +
      Regexp.last_match[2] +
      Regexp.last_match[3] +
      CartoonistGem.dependencies[Regexp.last_match[2]] +
      Regexp.last_match[5]
    end

    File.write path, new_contents
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

    def dependencies
      {
        "actionpack-page_caching" => "~> 1.0",
        "devise" => "~> 3.0",
        "jquery-rails" => "~> 3.0",
        "jquery-ui-rails" => "~> 4.0",
        "minitar" => "~> 0.5",
        "omniauth-openid" => "~> 1.0",
        "railties" => "~> 4.0",
        "redcarpet" => "~> 3.0",
        "rubyzip" => "~> 0.9",
        "twitter" => "~> 4.8"
      }
    end
  end

  private
  def root_dir
    File.join File.dirname(__FILE__), @dir
  end

  def cd
    "cd #{root_dir}"
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
                   CartoonistGem.new("cartoonist-nginxtra"),
                   CartoonistGem.new("cartoonist-pages"),
                   CartoonistGem.new("cartoonist-suggestions"),
                   CartoonistGem.new("cartoonist-tags"),
                   CartoonistGem.new("cartoonist-twitter")]

task :default => :build

task :check_dependencies do
  CARTOONIST_GEMS.each &:check_dependencies
end

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
