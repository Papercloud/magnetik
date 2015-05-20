$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "magnetik/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "magnetik"
  s.version     = Magnetik::VERSION
  s.authors     = ["Anton Ivanopoulos"]
  s.email       = ["ai@papercloud.com"]
  s.homepage    = "http://www.papercloud.com.au"
  s.summary     = "TODO: Summary of Magnetik."
  s.description = "TODO: Description of Magnetik."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '>= 4.0.0'
  s.add_dependency 'responders'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '~> 3.0'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'appraisal'
end
