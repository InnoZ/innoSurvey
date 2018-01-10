RSpec.describe Survey, type: :model do
  context "Attributes" do
    it "should respond to description" do 
      expect(Survey.new).to respond_to(:description)
    end
  end

  context "Associations" do
    it { is_expected.to(have_many(:topics)) }

    it "should delete associated records when deleting a survey" do
      # Setup
      egSurvey = Survey.create(description: "TestDescription")
      egRole = Role.create(name: "std_user")
      egTopic = Topic.create(description: "topicDescription", survey: egSurvey, role: egRole)
      egStatement = Statement.create(style: "QA",text: "question?", topic: egTopic)
      egAnswer = Answer.create(result: "bla", statement: egStatement)


      # Execution + Assertion
      egSurvey.destroy
      expect(Topic.find_by(survey_id: egSurvey.id)).to be_nil

      # expect { egSurvey.destroy }.to change(Topic, :count).by(.1)
    end

    it "should respond to description" do 
      expect(Survey.new).to respond_to(:description)
    end
  end
end
