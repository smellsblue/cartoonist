Gem::Specification.new do |s|
  s.name          = "cartoonist"
  s.version       = "0.1.0"
  s.date          = Time.now.strftime "%Y-%m-%d"
  s.summary       = "Cartoonist Core"
  s.description   = "This provides the main functionality and plugin api for Cartoonist."
  s.license       = "MIT"
  s.authors       = ["Mike Virata-Stone"]
  s.email         = "reasonnumber@gmail.com"
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.homepage      = "http://reasonnumber.com/cartoonist"
  s.add_dependency "actionpack-page_caching", "~> 1.0"
  s.add_dependency "devise", "~> 3.2"
  s.add_dependency "jquery-rails", "~> 3.0"
  s.add_dependency "omniauth-openid", "~> 1.0"
  s.add_dependency "railties", "~> 4.0"
  s.add_dependency "redcarpet", "~> 3.0"
  s.add_dependency "rubyzip", "~> 1.0"
  s.add_dependency "minitar", "~> 0.5"
end
