# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'supido/version'

Gem::Specification.new do |gem|
  gem.name          = "supido"
  gem.version       = Supido::VERSION
  gem.authors       = ["Robson Mendonça"]
  gem.email         = ["robsonmwoc@gmail.com"]
  gem.summary       = %q{A performance test profiling tool}
  gem.description   = %q{Supido is a simple to use Ruby profiling tool it was built to facilitate the Apache Benchmark usage and parallelism}
  gem.homepage      = "https://github.com/robsonmwoc/Supido"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.licenses = ['MIT']

  gem.add_dependency 'activesupport', ['>= 3.0.0']

  gem.add_development_dependency 'bundler', ['>= 1.0.0']
  gem.add_development_dependency 'rake', ['>= 0']
  gem.add_development_dependency 'rspec', ['>= 0']
  gem.add_development_dependency 'rdoc', ['>= 0']

end
