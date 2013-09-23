Gem::Specification.new do |s|
  s.name          = "cartoonist-nginxtra"
  raise "Cannot find version file!" unless File.exists?(File.join(File.dirname(__FILE__), "../CARTOONIST_VERSION"))
  s.version       = File.read File.join(File.dirname(__FILE__), "../CARTOONIST_VERSION")
  s.date          = Time.now.strftime "%Y-%m-%d"
  s.summary       = "Cartoonist Nginxtra Plugin"
  s.description   = "This gives Nginxtra plugins for Cartoonist sites."
  s.license       = "MIT"
  s.authors       = ["Mike Virata-Stone"]
  s.email         = "reasonnumber@gmail.com"
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.homepage      = "https://github.com/mikestone/cartoonist"
  s.add_dependency "nginxtra", ">= 1.4.2.9"
end
