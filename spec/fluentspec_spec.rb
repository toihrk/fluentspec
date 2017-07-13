# frozen_string_literal: true

require 'spec_helper'

describe Fluentspec do
  it 'has a version number' do
    expect(Fluentspec::VERSION).not_to be nil
  end

  describe '.setup' do
    it 'has a `setup` method as module function' do
      expect(Fluentspec.respond_to?(:setup)).to be true
    end

    context 'after setup' do
      before do
        Fluentspec.setup File.join(FIXTURE_PATH, 'valid.conf')
      end

      it 'should ready' do
        expect(Fluentspec.ready?).to be true
      end

      it 'should return Fluent::EngineClass from .engine' do
        expect(Fluentspec.engine).to be_kind_of(Fluent::EngineClass)
      end

      it 'should return Fluent::RootAgent from .root_agent' do
        expect(Fluentspec.root_agent).to be_kind_of(Fluent::RootAgent)
      end

      it 'should return Fluent::EventRouter from .event_router' do
        expect(Fluentspec.event_router).to be_kind_of(Fluent::EventRouter)
      end

      %i[inputs filters outputs].each do |m|
        it "should return Array from .#{m}" do
          expect(Fluentspec.send(m)).to be_kind_of(Array)
        end
      end
    end
  end

  %i[engine root_agent inputs filters outputs event_router].each do |m|
    it "has a `#{m}` method as module function" do
      expect(Fluentspec.respond_to?(m)).to be true
      expect(Fluentspec.send(m)).to be nil
    end
  end

  describe '.cleanup' do
    it 'has a `cleanup` method as module function' do
      expect(Fluentspec.respond_to?(:cleanup)).to be true
    end

    context 'after setup' do
      before do
        Fluentspec.cleanup
      end

      it 'should not ready' do
        expect(Fluentspec.ready?).to be false
      end
    end
  end
end
