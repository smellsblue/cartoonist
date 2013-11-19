Gem::Specification.new do |s|
  s.name          = "cartoonist-pages"
  s.version       = "0.0.20"
  s.date          = Time.now.strftime "%Y-%m-%d"
  s.summary       = "Cartoonist Pages"
  s.description   = "This core plugin for Cartoonist adds arbitrary pages."
  s.license       = "MIT"
  s.authors       = ["Mike Virata-Stone"]
  s.email         = "reasonnumber@gmail.com"
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.homepage      = "http://reasonnumber.com/cartoonist"
  s.add_dependency "jquery-rails", "~> 3.0"
  s.add_dependency "cartoonist", "~> 0.0.20.0"
end
