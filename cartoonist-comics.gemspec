Gem::Specification.new do |s|
  s.name          = "cartoonist-comics"
  s.version       = "0.0.4"
  s.date          = Time.now.strftime "%Y-%m-%d"
  s.summary       = "Cartoonist Comics"
  s.description   = "This core plugin for Cartoonist adds comics."
  s.authors       = ["Mike Virata-Stone"]
  s.email         = "reasonnumber@gmail.com"
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.homepage      = "http://reasonnumber.com/cartoonist"
end
