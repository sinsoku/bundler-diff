# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bundler_diff/version'

Gem::Specification.new do |spec|
  spec.name          = 'bundler-diff'
  spec.version       = BundlerDiff::VERSION
  spec.authors       = ['sinsoku']
  spec.email         = ['sinsoku.listy@gmail.com']

  spec.summary       = 'A gem support your "bundle update"'
  spec.description   = 'BundlerDiff show changes with GitHub comapre view urls.'
  spec.homepage      = 'https://github.com/sinsoku/bundler-diff'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'gems_comparator'
  spec.add_dependency 'parallel'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.56.0'
end
