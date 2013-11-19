Gem::Specification.new do |s|
  s.name          = "cartoonist-default-theme"
  s.version       = "0.1.0"
  s.date          = Time.now.strftime "%Y-%m-%d"
  s.summary       = "Cartoonist Default Theme"
  s.description   = "A plugin gem to provide the default theme for a Cartoonist website"
  s.license       = "MIT"
  s.authors       = ["Mike Virata-Stone"]
  s.email         = "reasonnumber@gmail.com"
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.homepage      = "http://reasonnumber.com/cartoonist"
  s.add_dependency "cartoonist", "~> 0.1.0"
end
