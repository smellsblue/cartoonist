Gem::Specification.new do |s|
  s.name          = "cartoonist-pages"
  s.version       = "0.0.4"
  s.date          = Time.now.strftime "%Y-%m-%d"
  s.summary       = "Cartoonist Pages"
  s.description   = "This core plugin for Cartoonist adds arbitrary pages."
  s.authors       = ["Mike Virata-Stone"]
  s.email         = "reasonnumber@gmail.com"
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.homepage      = "http://reasonnumber.com/cartoonist"
end
