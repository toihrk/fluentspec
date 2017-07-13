# frozen_string_literal: true

require 'fluent/plugin'
require 'fluent/supervisor'

module Fluent
  class Supervisor
    def run_spec
      read_config
      set_system_config

      change_privilege
      init_engine
      run_configure
    end
  end

  class EventRouter
    class Pipeline
      def filters
        @filters ||= []
      end

      def output
        @output ||= nil
      end
    end
  end
end

module Fluentspec
  class Supervisor
    def initialize(conf = nil)
      raise ArgumentError if conf.nil?
      @conf = conf
      opts = Fluent::Supervisor.default_options
      opts[:config_path] = @conf
      @sv = Fluent::Supervisor.new(opts)
      @sv.run_spec
    end

    # rubocop:disable Lint/HandleExceptions
    def reset
      opts = Fluent::Supervisor.default_options
      @sv = Fluent::Supervisor.new(opts)
      @sv.run_spec
    rescue
    end
  end
  # rubocop:enable Lint/HandleExceptions
end

# rubocop:disable all
def $log.method_missing(_method, *_args); end
# rubocop:enable all
