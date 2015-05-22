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
  s.summary     = "Rails engine for credit card management via Stripe."
  s.description = "Magnetik is a mountable rails engine that allows a model to be turned into a vessel for a Stripe customer, " <<
                  "as well as providing routes for credit card management via Stripe, including creating, updating and deleting " <<
                  "credit cards."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '>= 4.0.0'
  s.add_dependency 'responders'
  s.add_dependency 'stripe'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '~> 3.0'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'stripe-ruby-mock', '~> 2.1.1'
end
