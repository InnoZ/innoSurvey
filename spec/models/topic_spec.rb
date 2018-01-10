RSpec.describe Topic, type: :model do
  context "Attributes" do
    it "should respond to description" do
      expect(Topic.new).to(respond_to(:description))
    end
  end

  context "Associations" do
    it { is_expected.to(belong_to(:survey)) }
    it { is_expected.to(belong_to(:role)) }
  end
end
