# coding: utf-8
require File.expand_path('../lib/rjl/version', __FILE__)

Gem::Specification.new do |spec|
  spec.author        = 'Richard Lyon'
  spec.email         = 'richard@richardlyon.net'
  spec.name          = 'rjl-itunes'
  spec.summary       = %q{A ruby client for Apple's iTunes}
  spec.version       = RJL::VERSION
  spec.date          = '2016-03-19'
  spec.homepage      = 'https://github.com/richardjlyon/rjl-itunes'
  spec.license       = 'MIT'
  spec.files         = ['lib/rjl_itunes.rb']
  spec.require_path  = 'lib'
  spec.description   = <<-END
A long description.
END

end
