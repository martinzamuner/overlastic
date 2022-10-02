require_relative "lib/overlastic/version"

Gem::Specification.new do |s|
  s.name     = "overlastic"
  s.version  = Overlastic::VERSION
  s.authors  = ["Martin Zamuner"]
  s.email    = "martinzamuner@gmail.com"
  s.summary  = "Fantastically easy overlays using Hotwire. Bring your dialog modals and slide-out panes to life."
  s.homepage = "https://github.com/martinzamuner/overlastic"
  s.license  = "MIT"

  s.required_ruby_version = ">= 2.5.0"

  s.add_dependency "actionpack", ">= 6.1.0"
  s.add_dependency "railties", ">= 6.1.0"
  s.add_dependency "turbo-rails", ">= 1.3.0"

  s.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
end
