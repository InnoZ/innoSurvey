RSpec.describe Choice, type: :model do
  context "Attributes" do
    it { is_expected.to respond_to(:text) }
    it { is_expected.to respond_to(:to_json) }
  end

  context 'Instance methods' do
    it 'can query corresponding survey' do
      choice = create :choice

      expect(choice.statement.statement_set.topic.station.survey).to eq choice.survey
    end

    it 'is expected to serialize do JSON properly' do
      choice = create :choice

      expectation = {
        id: choice.id,
        text: choice.text,
      }

      expect(choice.to_json).to eq expectation
    end
  end

  context "Associations" do
    it { is_expected.to(belong_to(:statement)) }
  end
end
