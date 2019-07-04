# frozen_string_literal: true

RSpec.describe AWS::SNS::Configurator::Topic, type: :model do
  describe '#initialize' do
    before { allow_any_instance_of(described_class).to receive(:account_id).and_return('123456789') }
    subject { described_class.new(options) }

    context 'without name' do
      let(:options) { {} }

      it 'should raise RequiredFieldError' do
        expect { subject }.to raise_error(described_class::RequiredFieldError, 'The field name is required')
      end
    end

    context 'without region' do
      let(:options) { { name: 'update_price' } }

      it 'should raise RequiredFieldError' do
        expect { subject }.to raise_error(described_class::RequiredFieldError, 'The field region is required')
      end
    end

    context 'without all options' do
      let(:options) do
        {
          name: 'update_price',
          region: 'us-east-1',
          prefix: 'prices',
          suffix: 'warning',
          environment: 'production',
          metadata: {
            type: 'strict'
          }
        }
      end

      it 'should have accessors' do
        expect(subject.name).to eq('update_price')
        expect(subject.region).to eq('us-east-1')
        expect(subject.prefix).to eq('prices')
        expect(subject.suffix).to eq('warning')
        expect(subject.environment).to eq('production')
        expect(subject.metadata[:type]).to eq('strict')
        expect(subject.name_formatted).to eq('prices_production_update_price_warning')
        expect(subject.arn).to eq('arn:aws:sns:us-east-1:123456789:prices_production_update_price_warning')
      end
    end
  end

  describe '#create!' do
    let(:topic) { build :topic }
    let(:client) { build :client }
    subject { topic.create!(client) }

    it 'should create the topic', :vcr do
      expect(subject.topic_arn).to eq(topic.arn)
    end
  end

  describe '#find!' do
    let(:client) { build :client }
    subject { topic.find!(client) }

    context 'with existing topic' do
      let(:topic) { build :topic }

      it 'should find the topic', :vcr do
        is_expected.to be_truthy
      end
    end

    context 'without existing topic' do
      let(:topic) { build :topic, arn: "arn:aws:sns:us-east-1:#{ENV['AWS_ACCOUNT_ID']}:prices_production_update_price_warning" }

      it 'shouldnt find the topic', :vcr do
        is_expected.to be_falsey
      end
    end
  end

  describe '#subscribe!' do
    let(:topic) { build :topic }
    let(:client) { build :client }
    let(:protocol) { 'sqs' }
    let(:endpoint) { "arn:aws:sqs:us-east-1:#{ENV['AWS_ACCOUNT_ID']}:linqueta_production_queue_failures" }
    let(:raw) { true }

    subject { topic.subscribe!(client, protocol, endpoint, raw: raw) }

    after { subject }

    it 'should create subscription in the topic', :vcr do
      is_expected.to be_truthy
    end

    it 'should add raw attribute', :vcr do
      expect(topic).to receive(:raw_attribute).once.and_call_original
    end

    it 'should call to add attributes', :vcr do
      expect(topic).to receive(:subscription_attributes!).once.and_call_original
    end
  end
end
