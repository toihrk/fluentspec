# frozen_string_literal: true

require 'spec_helper'

describe 'match' do
  subject do
    Fluentspec.event_router.match(tag)
  end

  context 'kubernetes.var.log.containers.**.log' do
    let(:tag) { 'kubernetes.var.log.containers.example.log' }

    it 'should have filters and output' do
      expect(subject).to be_an_instance_of Fluent::EventRouter::Pipeline

      filters = subject.filters
      output = subject.output
      expect(filters.size).to eq(2)
      expect(output).not_to be nil
    end

    it 'has KubernetesMetadataFilter' do
      filters = subject.filters
      kubernetes_metadata_filter = filters.find do |f|
        f.is_a? Fluent::KubernetesMetadataFilter
      end

      expect(kubernetes_metadata_filter).not_to be nil
      expect(kubernetes_metadata_filter.kubernetes_url).to be nil
    end

    it 'has RecordTransformerFilter' do
      filters = subject.filters
      record_transformer_filter = filters.find do |f|
        f.is_a? Fluent::RecordTransformerFilter
      end
      expect(record_transformer_filter).not_to be nil
      expect(record_transformer_filter.enable_ruby).to be true

      config = record_transformer_filter.config
      record_config = config.elements.find { |e| e.name == 'record' }

      expect(record_config['role']).to eq('${record["kubernetes"]["labels"]["app"]}')
      expect(record_config.key?('container_name')).to be true
      expect(record_config['container_name']).to eq('${record["kubernetes"]["container_name"]}')
    end

    it 'has RewriteTagFilterOutput' do
      output = subject.output
      expect(output).to be_an_instance_of Fluent::RewriteTagFilterOutput

      rewrite_tag = output.rewrite_tag tag, 'role' => 'example'
      expect(rewrite_tag).to eq('service.example')
    end
  end

  context 'service.**' do
    let(:tag) { 'service.example' }

    it 'should match RewriteTagFilterOutput' do
      expect(subject).to be_an_instance_of Fluent::RewriteTagFilterOutput

      rewrite_tag = subject.rewrite_tag tag, 'container_name' => 'web'
      expect(rewrite_tag).to eq('nginx.service.example')
    end
  end

  context 'nginx.**' do
    let(:tag) { 'nginx.service.example' }

    it 'should match RewriteTagFilterOutput' do
      expect(subject).to be_an_instance_of Fluent::RewriteTagFilterOutput
    end

    context 'stream => stdout' do
      let(:record) { { 'stream' => 'stdout' } }
      it 'should rewrite tag access.nginx.service.example' do
        rewrite_tag = subject.rewrite_tag tag, record
        expect(rewrite_tag).to eq('access.nginx.service.example')
      end
    end

    context 'stream => stderr' do
      let(:record) { { 'stream' => 'stderr' } }
      it 'should rewrite tag error.nginx.service.example' do
        rewrite_tag = subject.rewrite_tag tag, record
        expect(rewrite_tag).to eq('error.nginx.service.example')
      end
    end
  end

  context 'access.nginx.**' do
    let(:tag) { 'access.nginx.service.example' }

    it 'should have filters and output' do
      expect(subject).to be_an_instance_of Fluent::EventRouter::Pipeline

      filters = subject.filters
      output = subject.output
      expect(filters.size).to eq(1)
      expect(output).not_to be nil
    end

    it 'has ParserFilter' do
      filters = subject.filters
      parser_filter = filters.find do |f|
        f.is_a? Fluent::ParserFilter
      end

      expect(parser_filter).not_to be nil
      config = parser_filter.config
      expect(config['format']).to eq('ltsv')
      expect(config['key_name']).to eq('log')
      expect(config.key?('reserve_data')).to be true
    end

    it 'has KinesisFirehoseOutput' do
      output = subject.output
      expect(output).to be_an_instance_of Fluent::KinesisFirehoseOutput
      expect(output.include_time_key).to be true
      expect(output.region).to eq('dummy-region')
      expect(output.delivery_stream_name).to eq('dummy-stream')
    end
  end

  context 'error.nginx.**' do
    let(:tag) { 'error.nginx.service.example' }

    it 'should have filters and output' do
      expect(subject).to be_an_instance_of Fluent::EventRouter::Pipeline

      filters = subject.filters
      output = subject.output
      expect(filters.size).to eq(2)
      expect(output).not_to be nil
    end

    it 'has ConcatFilter' do
      filters = subject.filters
      concar_filter = filters.find do |f|
        f.is_a? Fluent::ConcatFilter
      end

      expect(concar_filter).not_to be nil
    end

    it 'has ParserFilter' do
      filters = subject.filters
      parser_filter = filters.find do |f|
        f.is_a? Fluent::ParserFilter
      end

      expect(parser_filter).not_to be nil
      config = parser_filter.config
      expect(config['format']).to eq('multiline')
    end

    it 'has SlackOutput' do
      output = subject.output
      expect(output).to be_an_instance_of Fluent::SlackOutput

      expect(output.slackbot_url).to eq('https://dummy')
      expect(output.channel).to eq('#nginx-error')
    end
  end
end
