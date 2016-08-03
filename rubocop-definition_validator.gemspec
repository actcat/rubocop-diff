# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubocop/definition_validator/version'

Gem::Specification.new do |spec|
  spec.name          = "rubocop-definition_validator"
  spec.version       = Rubocop::DefinitionValidator::VERSION
  spec.authors       = ["Masataka Kuwabara"]
  spec.email         = ["p.ck.t22@gmail.com"]

  spec.summary       = %q{This tool detects omission of modification of callers when the name of a method, number of arguments, or the name of a keyword argument is modified.}
  spec.description   = %q{This tool detects omission of modification of callers when the name of a method, number of arguments, or the name of a keyword argument is modified.}
  spec.homepage      = "https://github.com/actcat/rubocop-definition_validator"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.licenses = ['MIT']

  spec.add_runtime_dependency 'rubocop', '~> 0.42.0'
  spec.add_runtime_dependency 'git_diff_parser', '>= 2.2.0'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency "rspec", "~> 3.4.0"
  spec.add_development_dependency 'guard', '~> 2.13.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.6.5'
  spec.add_development_dependency 'guard-bundler', '~> 2.1.0'
  spec.add_development_dependency 'pry', '~> 0.10.3'
  spec.add_development_dependency 'rspec-power_assert', '~> 0.3.0'
  spec.add_development_dependency 'pry_testcase', '~> 0.3.0'
end
