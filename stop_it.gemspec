Gem::Specification.new do |gem|
  gem.authors       = ['Andrei Gridnev']
  gem.email         = ['andrew.gridnev@gmail.com']
  gem.description   = 'Middleware for blocking requests to rake apps
    based on user agent, remote IP, and other environment variables.'
  gem.summary       = 'Middleware for blocking requests to rake apps.'
  gem.homepage      = 'https://github.com/andrewgr/stop_it/'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($ORS)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.name          = 'stop_it'
  gem.require_paths = ['lib']
  gem.version       = '2.0.0'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rubocop', '~> 0.30'
  gem.add_development_dependency 'cane', '~> 2.6', '>= 2.6.1'
end
