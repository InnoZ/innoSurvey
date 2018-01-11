RSpec.describe Survey, type: :model do
  context "Attributes" do
    it "should respond to description" do 
      expect(Survey.new).to respond_to(:description)
    end
  end

  context "Associations" do
    it { is_expected.to(have_many(:stations)) }

    it "should delete associated records when deleting a survey" do
      survey = create :survey
      station = create :station, survey: survey

      expect { survey.destroy }.to change(Survey, :count).by(-1)
    end

    it "should respond to description" do 
      expect(Survey.new).to respond_to(:description)
    end
  end
end
