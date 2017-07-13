# frozen_string_literal: true

ENV['BUNDLE_GEMFILE'] ||= File.expand_path '../../Gemfile', __FILE__

require 'bundler'
Bundler.setup

require 'rspec'
require 'fluentspec'
Fluentspec.setup File.expand_path('../../fluent.conf', __FILE__)
