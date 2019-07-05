# frozen_string_literal: true

RSpec.describe AWS::SNS::Configurator::Reader, type: :model do
  describe 'PATH' do
    subject { described_class::PATH }

    it 'should catch from config' do
      is_expected.to eq('./config/aws-sns-configurator.yml')
    end
  end

  describe '#initialize' do
    before { stub_const("#{described_class}::PATH", "./spec/fixtures/configs/#{file}.yml") }

    context 'without file' do
      let(:file) { 'a' }

      it 'should set config as emtpy hash' do
        expect(subject.config).to eq(topics: [])
      end
    end

    context 'with empty config' do
      let(:file) { 'empty_config' }

      it 'should set config as emtpy hash' do
        expect(subject.config).to eq(topics: [])
      end
    end

    context 'without topics' do
      let(:file) { 'without_topics' }

      it 'should set config with default fields' do
        expect(subject.config).to eq(
          region: 'us-east-1',
          prefix: 'prices',
          suffix: 'failures',
          environment: 'production',
          topics: []
        )
      end
    end

    context 'with topics' do
      let(:file) { 'with_topics' }

      it 'should set config with default fields' do
        expect(subject.config).to eq(
          region: 'us-east-1',
          prefix: 'prices',
          suffix: 'warning',
          environment: 'production',
          topics: [
            {
              name: 'prices_update',
              region: 'us-east-2'
            },
            {
              name: 'prices_adjuster',
              suffix: 'alert',
              region: 'sa-east-1'
            }
          ]
        )
      end
    end
  end

  describe '#topics' do
    before { stub_const("#{described_class}::PATH", "./spec/fixtures/configs/#{file}.yml") }
    subject { described_class.new.topics! }

    context 'without file' do
      let(:file) { 'a' }

      it 'should be an empty array' do
        expect(subject).to eq([])
      end
    end

    context 'with empty config' do
      let(:file) { 'empty_config' }

      it 'should be an empty array' do
        expect(subject).to eq([])
      end
    end

    context 'without topics' do
      let(:file) { 'without_topics' }

      it 'should be an empty array' do
        expect(subject).to eq([])
      end
    end

    context 'with topics' do
      let(:file) { 'without_failures_by_default' }

      it 'should return 2 topics' do
        expect(subject.length).to eq(2)
      end

      it 'should return topics' do
        expect(subject.all? { |topic| topic.is_a?(AWS::SNS::Configurator::Topic) }).to be_truthy
      end
    end
  end
end
