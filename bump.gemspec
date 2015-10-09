# coding: utf-8
require File.expand_path '../lib/bump/version', __FILE__

Gem::Specification.new do |s|
  s.name          = 'bump'
  s.version       = Bump::VERSION
  s.authors       = ['Pavol Zbell']
  s.email         = ['pavol.zbell@gmail.com']

  s.summary       = 'Bump versions with ease'
  s.description   = 'Easily bump version of your Gem or Rails application all in sync with remote Git repository, supports custom commit messages, tag names, and more.'
  s.homepage      = 'https://github.com/pavolzbell/bump'
  s.license       = 'MIT'

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(s)/}) }
  s.bindir        = 'bin'
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.10'
  s.add_development_dependency 'rake',    '~> 10.0'
  s.add_development_dependency 'rspec',   '~> 3.3.0'
  s.add_development_dependency 'aruba',   '~> 0.9.0'
end
