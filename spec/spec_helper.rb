# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rspec'
require 'fluentspec'
require 'fluent/version'

FLUENT_VERSION = Fluent::VERSION.split('.').tap(&:pop).join('.')
FIXTURE_PATH = File.expand_path('../fixtures', __FILE__)
