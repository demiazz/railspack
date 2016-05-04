lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'railspack/version'

Gem::Specification.new do |spec|
  spec.name          = 'railspack'
  spec.version       = Railspack::VERSION
  spec.authors       = ['Alexey Plutalov']
  spec.email         = ['demiazz.py@gmail.com']
  spec.homepage      = 'https://github.com/demiazz/railspack'
  spec.summary       = 'Webpack integration to Rails projects'
  spec.description   = 'Tools for integrate webpack to your Rails projects'
  spec.license       = 'MIT'

  spec.name          = 'railspack'
  spec.require_paths = ['lib']
  spec.files         = Dir[
    'lib/**/*', 'CODE_OF_CONDUCT.md', 'Gemfile', 'Gemfile.lock', 'LICENSE.txt',
    'railspack.gemspec', 'Rakefile', 'README.md'
  ]
  spec.test_files    = Dir['test/**/*']

  spec.add_dependency 'rails', '>= 3.1.0'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'appraisal'
end
