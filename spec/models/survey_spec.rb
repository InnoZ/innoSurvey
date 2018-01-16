RSpec.describe Survey, type: :model do
  context "Attributes" do
    it "should respond to description" do 
      expect(Survey.new).to respond_to(:description)
      expect(Survey.new).to respond_to(:name)
    end
  end

  context 'Instance methods' do
    it 'is expected to serialize JSON properly' do
      choice = create :choice
      survey = choice.survey

      expectation = {
        id: survey.id,
        name: survey.name,
        stations: survey.stations.map(&:to_json)
      }

      expect(survey.to_json).to eq expectation
    end
  end

  context "Associations" do
    it { is_expected.to(have_many(:stations)) }
    it { is_expected.to(belong_to(:user)) }

    it "should delete associated records when deleting a survey" do
      survey = create :survey
      create :station, survey: survey

      expect { survey.destroy }.to change(Station, :count).by(-1)
    end

    it "should respond to description" do 
      expect(Survey.new).to respond_to(:description)
    end
  end
end
