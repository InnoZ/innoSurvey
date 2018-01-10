RSpec.describe Role, type: :model do
  context "Attributes" do
    it "should respond to name" do 
      expect(Role.new).to respond_to(:name)
    end
  end

  context "Associations" do
    it { is_expected.to(have_many(:topics)) }

    it "should respond to name" do 

      expect(Role.new).to respond_to(:name)
    end
  end
end
