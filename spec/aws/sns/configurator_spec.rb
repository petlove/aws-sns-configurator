# frozen_string_literal: true

RSpec.describe AWS::SNS::Configurator do
  it 'has a version number' do
    expect(AWS::SNS::Configurator::VERSION).not_to be nil
  end

  describe '#create!' do
    subject { described_class.create!(force) }

    after { subject }

    context 'default' do
      let(:force) { false }

      it 'should use the class Creator to create the topics' do
        expect_any_instance_of(described_class::Creator).to receive(:initialize).with(false).once
        expect_any_instance_of(described_class::Creator).to receive(:create!).once
      end
    end

    context 'forced' do
      let(:force) { true }

      it 'should use the class Creator to create the topics' do
        expect_any_instance_of(described_class::Creator).to receive(:initialize).with(true).once
        expect_any_instance_of(described_class::Creator).to receive(:create!).once
      end
    end
  end

  describe '#subscribe!' do
    let(:topic) { build :topic }
    subject { described_class.subscribe!(topic, protocol, endpoint, raw: raw) }

    after { subject }

    context 'protocol sqs' do
      let(:protocol) { 'sqs' }
      let(:endpoint) { 'arn' }
      let(:raw) { true }

      it 'should use subscribe through the topic' do
        expect(topic).to receive(:subscribe!).once
      end
    end
  end

  describe '#subscribe!' do
    subject { described_class.read! }

    after { subject }

    it 'should use reader to get topics' do
      expect_any_instance_of(described_class::Reader).to receive(:topics!)
    end
  end
end
