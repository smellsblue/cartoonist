Gem::Specification.new do |s|
  raise "Cannot find version file!" unless File.exists?(File.join(File.dirname(__FILE__), "../CARTOONIST_VERSION"))
  cartoonist_version = File.read(File.join(File.dirname(__FILE__), "../CARTOONIST_VERSION")).strip
  s.name          = "cartoonist-default-theme"
  s.version       = cartoonist_version
  s.date          = Time.now.strftime "%Y-%m-%d"
  s.summary       = "Cartoonist Default Theme"
  s.description   = "A plugin gem to provide the default theme for a Cartoonist website"
  s.license       = "MIT"
  s.authors       = ["Mike Virata-Stone"]
  s.email         = "reasonnumber@gmail.com"
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.homepage      = "http://reasonnumber.com/cartoonist"
  s.add_dependency "cartoonist", cartoonist_version
end
