# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'odesk/jobnotifier/version'

Gem::Specification.new do |spec|
  spec.name          = 'odesk-jobnotifier'
  spec.version       = Odesk::Jobnotifier::VERSION
  spec.authors       = ['Anton Kolomiychuk']
  spec.email         = ['kolomiychuk.anton+gh@gmail.com']
  spec.summary       = 'Get real-time notifications about new jobs on Odesk on your Mac.'
  spec.homepage      = 'https://github.com/akolomiychuk/odesk-jobnotifier'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
end
