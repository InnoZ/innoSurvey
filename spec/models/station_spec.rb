RSpec.describe Station, type: :model do
  context 'Associations' do
    it { is_expected.to have_many(:topics) }
    it { is_expected.to belong_to(:survey) }
  end
end
