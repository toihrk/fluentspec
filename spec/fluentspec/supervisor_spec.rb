# frozen_string_literal: true

require 'spec_helper'

describe Fluentspec::Supervisor do
  describe '#initialize' do
    let(:conf) { nil }
    subject { Fluentspec::Supervisor.new(conf) }

    it 'should raise ArgumentError' do
      expect { subject }.to raise_error ArgumentError
    end

    context 'provide broken config' do
      let(:conf) { File.join(FIXTURE_PATH, 'broken.conf') }
      it 'should raise Fluent::ConfigParseError' do
        expect { subject }.to raise_error Fluent::ConfigParseError
      end
    end

    context 'provide valid config' do
      let(:conf) { File.join(FIXTURE_PATH, 'valid.conf') }
      it 'should success parsing configuration' do
        subject
        config = Fluent::Engine.root_agent.config
        expect(config).to be_an_instance_of(Fluent::Config::Element)
      end

      it 'has inputs' do
        subject
        inputs = Fluent::Engine.root_agent.inputs
        expect(inputs.size).to eq(1)
      end

      it 'has outputs' do
        subject
        outputs = Fluent::Engine.root_agent.outputs
        expect(outputs.size).to eq(1)
      end
    end
  end
end
