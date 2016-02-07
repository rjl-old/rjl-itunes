# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rjl_itunes/version"

GEM_VERSION = Rjl_itunes::VERSION

Gem::Specification.new do |spec|
  spec.name          = 'rjl_itunes'
  spec.version       = GEM_VERSION
  spec.date          = '2016-02-07'
  spec.author        = 'Richard Lyon'
  spec.email         = 'richard@richardlyon.net'
  spec.homepage      = 'https://github.com/richardjlyon/rjl_itunes'
  spec.summary       = %q{}
  spec.license       = 'MIT'
  spec.files         = ['lib/rjl_itunes.rb']
  spec.require_path  = 'lib'
  spec.description   = <<-END
A long description.
END

end
