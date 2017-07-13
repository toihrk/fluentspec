# frozen_string_literal: true

ENV['BUNDLE_GEMFILE'] ||= File.expand_path '../Gemfile', __FILE__

require 'bundler'
Bundler.require

Fluentspec.setup File.expand_path '../fluent.conf', __FILE__

Pry.start
