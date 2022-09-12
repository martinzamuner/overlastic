require_relative "lib/overlastic/version"

Gem::Specification.new do |s|
  s.name     = "overlastic"
  s.version  = Overlastic::VERSION
  s.authors  = ["Martin Zamuner"]
  s.email    = "martinzamuner@gmail.com"
  s.summary  = "Fantastically easy overlays using Hotwire."
  s.homepage = "https://github.com/martinzamuner/overlastic"
  s.license  = "MIT"

  s.required_ruby_version = ">= 2.6.0"

  s.add_dependency "activejob", ">= 6.0.0"
  s.add_dependency "actionpack", ">= 6.0.0"
  s.add_dependency "railties", ">= 6.0.0"

  s.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
end
