RSpec.describe Role, type: :model do

  it "should respond to name" do 

    expect(Role.new).to respond_to(:name)
  end
end
