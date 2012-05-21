Gem::Specification.new do |s|
  raise "Cannot find version file!" unless File.exists?(File.join(File.dirname(__FILE__), "../CARTOONIST_VERSION"))
  cartoonist_version = File.read(File.join(File.dirname(__FILE__), "../CARTOONIST_VERSION")).strip
  s.name          = "cartoonist-comics"
  #s.version       = cartoonist_version
  s.version       = "0.0.9.1"
  s.date          = Time.now.strftime "%Y-%m-%d"
  s.summary       = "Cartoonist Comics"
  s.description   = "This core plugin for Cartoonist adds comics."
  s.authors       = ["Mike Virata-Stone"]
  s.email         = "reasonnumber@gmail.com"
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.homepage      = "http://reasonnumber.com/cartoonist"
  #s.add_dependency "cartoonist", cartoonist_version
  s.add_dependency "cartoonist", "0.0.9"
end
