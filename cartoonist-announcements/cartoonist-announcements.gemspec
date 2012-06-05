Gem::Specification.new do |s|
  raise "Cannot find version file!" unless File.exists?(File.join(File.dirname(__FILE__), "../CARTOONIST_VERSION"))
  cartoonist_version = File.read(File.join(File.dirname(__FILE__), "../CARTOONIST_VERSION")).strip
  s.name          = "cartoonist-announcements"
  s.version       = cartoonist_version
  s.date          = Time.now.strftime "%Y-%m-%d"
  s.summary       = "Cartoonist Announcements"
  s.description   = "This plugin for Cartoonist adds announcements for things like announcing a new website."
  s.authors       = ["Mike Virata-Stone"]
  s.email         = "reasonnumber@gmail.com"
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.homepage      = "http://reasonnumber.com/cartoonist"
  s.add_dependency "cartoonist", cartoonist_version
end
