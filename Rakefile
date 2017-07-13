# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'appraisal'

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec) do |s|
  s.rspec_opts = %w[--format documentation --color]
end

if !ENV['APPRAISAL_INITIALIZED'] && !ENV['TRAVIS']
  task default: %i[rubocop appraisal]
else
  task default: %i[spec]
end
