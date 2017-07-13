# frozen_string_literal: true

require 'fluentspec/version'
require 'fluentspec/supervisor'

module Fluentspec
  @ready = false

  module_function

  def ready?
    @ready ||= false
  end

  def setup(config_file_path)
    @sv = Supervisor.new(config_file_path)
    @ready = true
  end

  def engine
    ::Fluent::Engine if Fluentspec.ready?
  end

  def root_agent
    Fluentspec.engine.root_agent if Fluentspec.ready?
  end

  def inputs
    Fluentspec.root_agent.inputs if Fluentspec.ready?
  end

  def filters
    Fluentspec.root_agent.filters if Fluentspec.ready?
  end

  def outputs
    Fluentspec.root_agent.outputs if Fluentspec.ready?
  end

  def event_router
    Fluentspec.root_agent.event_router if Fluentspec.ready?
  end

  def cleanup
    @sv.reset
    @ready = false
  end
end
