RSpec.describe Answer, type: :model do
  context "Attributes" do
    it "should respond to result" do 
      expect(Answer.new).to respond_to(:result)
    end
  end

  context "Associations" do
    it { is_expected.to(belong_to(:statement)) }
  end
end
