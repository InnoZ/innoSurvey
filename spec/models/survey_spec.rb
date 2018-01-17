RSpec.describe Survey, type: :model do
  context "Attributes" do
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:name_url_safe) }
  end

  context 'Instance methods' do
    it 'creates url_safe name before validation' do
      expect(create(:survey, name: 'Peter Pan').name_url_safe).to eq 'peter_pan'
      expect(create(:survey, name: "Peter's Pan").name_url_safe).to eq 'peters_pan'
      expect(create(:survey, name: "Peter's 123 Pan").name_url_safe).to eq 'peters_123_pan'
    end

    it 'is expected to serialize JSON properly' do
      create_choice_stack # Instanciate @survey

      expectation = {
        id: @survey.id,
        name: @survey.name,
        stations: @survey.stations.map(&:to_json)
      }.to_json

      expect(@survey.to_json).to eq expectation
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

  context 'Validations' do
    it 'should have unique name' do
      create :survey, name: 'Peter Pan'
      another_survey = build :survey, name: 'Peter Pan'

      expect(another_survey).not_to be_valid
    end

    it 'should have unique name_url_safe' do
      create :survey, name: 'peter_pan'
      another_survey = build :survey, name: 'Peter Pan'

      expect(another_survey).not_to be_valid
    end
  end
end
