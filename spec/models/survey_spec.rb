RSpec.describe Survey, type: :model do
  it "should respond to description" do 
    expect(Survey.new).to respond_to(:description)
  end
end
