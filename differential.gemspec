# frozen_string_literal: true

require './lib/differential/version'

Gem::Specification.new do |s|
  s.name        = 'differential'
  s.version     = Differential::VERSION
  s.summary     = 'Dataset Differential Engine'

  s.description = <<-DESCRIPTION
    Differential is a numeric-based library will compare two datasets and give you three
    levels of comparison: report, group, and item level.
    Each level provides the sum of each dataset and the difference.
  DESCRIPTION

  s.authors     = ['Matthew Ruggio']
  s.email       = ['mruggio@bluemarblepayroll.com']
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.homepage    = 'https://github.com/bluemarblepayroll/differential'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.3.1'

  s.add_development_dependency('guard-rspec', '~>4.7.3')
  s.add_development_dependency('rspec', '~> 3.8.0')
  s.add_development_dependency('rubocop', '~> 0.59.2')
end
