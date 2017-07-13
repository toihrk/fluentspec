# frozen_string_literal: true

require 'spec_helper'

describe 'inputs' do
  subject { Fluentspec.inputs }

  it 'has a input' do
    expect(subject.size).to eq(1)
  end

  it 'should be tail input' do
    tail = subject[0]
    expect(tail.path).to eq('/var/log/containers/*.log')
    expect(tail.tag).to eq('kubernetes.*')
  end
end
