RSpec.describe Choice, type: :model do
  context "Attributes" do
    it "should respond to text" do 
      binding.pry
      expect(Choice.new).to respond_to(:text)
    end
  end

  context "Associations" do
    it { is_expected.to(belong_to(:statement)) }
  end
end
