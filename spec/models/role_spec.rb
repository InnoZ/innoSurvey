RSpec.describe Role, type: :model do
  context "Attributes" do
    it { is_expected.to respond_to(:name) }
  end

  context "Associations" do
    it { is_expected.to(belong_to(:survey)) }
  end
end
