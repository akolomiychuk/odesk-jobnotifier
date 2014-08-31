# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'odesk_jobnotifier/version'

Gem::Specification.new do |spec|
  spec.name          = 'odesk-jobnotifier'
  spec.version       = OdeskJobnotifier::VERSION
  spec.authors       = ['Anton Kolomiychuk']
  spec.email         = ['kolomiychuk.anton+gh@gmail.com']
  spec.summary       = 'Get real-time notifications about new jobs on Odesk' \
                       ' on your Mac.'
  spec.homepage      = 'https://github.com/akolomiychuk/odesk-jobnotifier'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.0'

  spec.add_runtime_dependency 'odesk-jobfetch'
  spec.add_runtime_dependency 'terminal-notifier', '~> 1.6'

  spec.add_development_dependency 'rubocop', '~> 0.25'
  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
end
