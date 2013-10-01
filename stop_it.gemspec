Gem::Specification.new do |gem|
  gem.authors       = ["Andrew Gridnev"]
  gem.email         = ["andrew.gridnev@gmail.com"]
  gem.description   = %q{}
  gem.summary       = %q{Middleware for blocking requests to rake apps.}
  gem.homepage      = "https://github.com/andrewgr/stop_it/"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "stop_it"
  gem.require_paths = ["lib"]
  gem.version       = "1.0.0"

  gem.add_development_dependency 'rspec'
end
