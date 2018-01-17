RSpec.describe Station, type: :model do
  context 'Attributes' do
    it { is_expected.to respond_to(:name) }
  end

  context 'Associations' do
    it { is_expected.to have_many(:topics) }
    it { is_expected.to belong_to(:survey) }
     
    it "should delete associated records when deleting a station" do
      station = create :station
      create :topic, station: station

      expect { station.destroy }.to change( Topic, :count).by(-1)
    end
  end

  context 'Instance methods' do
    it 'is expected to serialize do JSON properly' do
      station = create :station

      expectation = {
        id: station.id,
        survey_id: station.survey.id,
        survey_name: station.survey.name,
        name: station.name,
        topics: station.topics.map(&:to_json)
      }.to_json

      expect(station.to_json).to eq expectation
    end
  end
end
