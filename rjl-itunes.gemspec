# coding: utf-8
require File.expand_path('../lib/rjl/version', __FILE__)

Gem::Specification.new do |spec|
  spec.author         = 'Richard Lyon'
  spec.email          = 'richard@richardlyon.net'
  spec.summary        = %q{A ruby client for Apple's iTunes}
  spec.description    = %q{Manage album track genre in the library  using data from allmusic.com}
  spec.homepage       = 'https://github.com/richardjlyon/rjl-itunes'

  spec.executables    = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.files          = `git ls-files`.split("\n")
  spec.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_path   = 'lib'

  spec.name           = 'rjl-itunes'
  spec.version        = RJL::VERSION
  spec.license        = 'MIT'

  spec.add_development_dependency 'rake', '~> 10.4', '>= 10.4.2'
  spec.add_runtime_dependency     'rjl-allmusic', '~> 0.5', '>= 0.5'
  spec.add_runtime_dependency     'rb-scpt', '~> 1.0', '>= 1.0.1'
  spec.add_runtime_dependency     'ruby-progressbar', '~> 1.7', '>= 1.7.5'
  spec.add_runtime_dependency     'daybreak', '~> 0.3', '>= 0.3.0'

end
