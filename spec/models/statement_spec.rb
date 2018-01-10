RSpec.describe Statement, type: :model do
  context "Attributes" do
    it "should respond to text" do 
      expect(Statement.new).to(respond_to(:text))
    end

    it "should respond to type" do 
      expect(Statement.new).to(respond_to(:type))
    end
  end
  context "Associations" do
    it { is_expected.to(belong_to(:topic)) }
  end
end
