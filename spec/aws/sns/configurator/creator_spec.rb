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

      it 'should call to find for each topic', :vcr do
        expect(instance).to receive(:find_topic).exactly(4).times
      end

      it 'should call to create for each topic', :vcr do
        expect(instance).to receive(:create_topic).exactly(4).times
      end

      it 'should call to create by region for each region' do
        expect(instance).to receive(:create_by_region).exactly(2).times
      end

      it 'should have 4 topics found', :vcr do
        expect(subject.found.length).to eq(4)
      end

      it 'shoult have 0 topic created', :vcr do
        expect(subject.created.length).to eq(0)
      end
    end

    context 'forced' do
      let(:force) { true }

      it 'shouldnt call to find', :vcr do
        expect(instance).not_to receive(:find_topic)
      end

      it 'should call to create for each topic', :vcr do
        expect(instance).to receive(:create_topic).exactly(4).times
      end

      it 'should call to create by region for each region' do
        expect(instance).to receive(:create_by_region).exactly(2).times
      end

      it 'should have 0 topics found', :vcr do
        expect(subject.found.length).to eq(0)
      end

      it 'shoult have 4 topic created', :vcr do
        expect(subject.created.length).to eq(4)
      end
    end
  end
end
