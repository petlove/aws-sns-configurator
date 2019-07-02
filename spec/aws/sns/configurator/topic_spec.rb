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
      context 'without failures' do
        let(:options) do
          {
            name: 'update_price',
            region: 'us-east-1',
            prefix: 'prices',
            suffix: 'warning',
            environment: 'production',
            tag: 'strict',
            failures: false
          }
        end

        it 'should have accessors' do
          expect(subject.name).to eq('update_price')
          expect(subject.region).to eq('us-east-1')
          expect(subject.prefix).to eq('prices')
          expect(subject.suffix).to eq('warning')
          expect(subject.environment).to eq('production')
          expect(subject.tag).to eq('strict')
          expect(subject.name_formatted).to eq('prices_production_update_price_warning')
          expect(subject.arn).to eq('arn:aws:sns:us-east-1:123456789:prices_production_update_price_warning')
          expect(subject.failures).to be_nil
        end
      end

      context 'with failures' do
        let(:options) do
          {
            name: 'update_price',
            region: 'us-east-1',
            prefix: 'prices',
            suffix: 'warning',
            environment: 'production',
            tag: 'strict',
            failures: true
          }
        end

        it 'should have accessors' do
          expect(subject.name).to eq('update_price')
          expect(subject.region).to eq('us-east-1')
          expect(subject.prefix).to eq('prices')
          expect(subject.suffix).to eq('warning')
          expect(subject.environment).to eq('production')
          expect(subject.tag).to eq('strict')
          expect(subject.name_formatted).to eq('prices_production_update_price_warning')
          expect(subject.arn).to eq('arn:aws:sns:us-east-1:123456789:prices_production_update_price_warning')
          expect(subject.failures).to be_a(described_class)
          expect(subject.failures.name).to eq('update_price')
          expect(subject.failures.region).to eq('us-east-1')
          expect(subject.failures.prefix).to eq('prices')
          expect(subject.failures.suffix).to eq('warning_failures')
          expect(subject.failures.environment).to eq('production')
          expect(subject.failures.tag).to eq('strict')
          expect(subject.failures.name_formatted).to eq('prices_production_update_price_warning_failures')
          expect(subject.failures.arn).to eq('arn:aws:sns:us-east-1:123456789:prices_production_update_price_warning_failures')
        end
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
      let(:topic) { build :topic, arn: 'arn:aws:sns:us-east-1:123456789:prices_production_update_price_warning' }

      it 'shouldnt find the topic', :vcr do
        is_expected.to be_falsey
      end
    end
  end
end
