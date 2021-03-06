Gem::Specification.new do |s|
  s.name          = "cartoonist-announcements"
  s.version       = "0.1.0"
  s.date          = Time.now.strftime "%Y-%m-%d"
  s.summary       = "Cartoonist Announcements"
  s.description   = "This plugin for Cartoonist adds announcements for things like announcing a new website."
  s.license       = "MIT"
  s.authors       = ["Mike Virata-Stone"]
  s.email         = "reasonnumber@gmail.com"
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.homepage      = "http://reasonnumber.com/cartoonist"
  s.add_dependency "cartoonist", "~> 0.1.0"
end
