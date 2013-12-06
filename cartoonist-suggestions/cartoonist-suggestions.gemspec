Gem::Specification.new do |s|
  s.name          = "cartoonist-suggestions"
  s.version       = "0.0.20.1"
  s.date          = Time.now.strftime "%Y-%m-%d"
  s.summary       = "Cartoonist Suggestions"
  s.description   = "Plugin for community suggestion feedback."
  s.license       = "MIT"
  s.authors       = ["Mike Virata-Stone"]
  s.email         = "reasonnumber@gmail.com"
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.homepage      = "http://reasonnumber.com/cartoonist"
  s.add_dependency "cartoonist", "~> 0.0.20.0"
end
