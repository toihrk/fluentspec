# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluentspec/version'

Gem::Specification.new do |s|
  s.name          = 'fluentspec'
  s.version       = Fluentspec::VERSION
  s.authors       = ['toihrk']
  s.email         = ['toihrk@me.com']

  s.summary       = 'fluentspec is testing tool for your fluentd configuration file.'
  s.description   = s.summary

  s.homepage      = 'https://github.com/toihrk/fluentspec'
  s.license       = 'MIT'

  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless s.respond_to?(:metadata)

  s.files = `git ls-files -z`.split(?\x0).reject { |f| f.match(%r{^(test|spec|features)/}) }

  s.require_paths = ['lib']

  s.add_dependency 'fluentd', '>= 0.12'

  s.add_development_dependency 'bundler', '~> 1.14'
  s.add_development_dependency 'rake', '~> 12'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-doc'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'rspec', '~> 3.6'
end
