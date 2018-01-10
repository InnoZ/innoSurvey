RSpec.describe Survey, type: :model do
<<<<<<< HEAD
  context "Attributes" do
    it "should respond to description" do 
      expect(Survey.new).to respond_to(:description)
    end
  end
  context "Associations" do
    it { is_expected.to(have_many(:topics)) }
  end
  it "should delete associated records when deleting a survey" do
    # Setup
    egSurvey = Survey.create(description: "TestDescription")
    egRole = Role.create(name: "std_user")
    egTopic = Topic.create(description: "topicDescription",survey_id: egSurvey, role_id: egRole)
    egStatement = Statement.create(style: "QA",text: "question?", topic_id: egTopic)
    egAnswer = Answer.create(result: "bla", statement_id: egStatement)
    # Execution
    
    # Assertion
  it "should respond to description" do 
    expect(Survey.new).to respond_to(:description)
  end
end
