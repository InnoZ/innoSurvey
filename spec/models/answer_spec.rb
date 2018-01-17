RSpec.describe Answer, type: :model do
  context "Attributes" do
    it "should respond to result" do 
      expect(Answer.new).to respond_to(:result)
    end
  end

  context "Associations" do
    it { is_expected.to(belong_to(:statement)) }
  end

  context 'Instance methods' do
    it 'can parse and return its results as ruby hash' do
      require 'pry'; binding.pry
    end
  end
end
