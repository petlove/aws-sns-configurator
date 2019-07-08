# frozen_string_literal: true

RSpec.describe AWS::SNS::Configurator::Creator, type: :model do
  describe '#initialize' do
    before { stub_const('AWS::SNS::Configurator::Reader::PATH', './spec/fixtures/configs/aws-sns-shoryuken.yml') }

    it 'should have created and found empty' do
      expect(subject.created).to be_empty
      expect(subject.found).to be_empty
    end

    it 'should get topics' do
      expect(subject.topics.all? { |t| t.is_a?(AWS::SNS::Configurator::Topic) }).to be_truthy
    end
  end

  describe '#create!' do
    let(:instance) { described_class.new(force) }
    subject { instance.create! }

    before { stub_const('AWS::SNS::Configurator::Reader::PATH', './spec/fixtures/configs/aws-sns-shoryuken.yml') }

    after { subject }

    context 'default' do
      let(:force) { false }

      it 'should have 2 topics found and 0 created', :vcr do
        puts AWS::SNS::Configurator.topics!
        puts Dir['./spec/fixtures/*']
        expect(subject.found.length).to eq(2)
        expect(subject.created.length).to eq(0)
      end
    end

    context 'forced' do
      let(:force) { true }

      it 'should have 2 topics found and 0 created', :vcr do
        expect(instance).not_to receive(:find_topic)
        expect(subject.found.length).to eq(0)
        expect(subject.created.length).to eq(2)
      end
    end
  end
end
