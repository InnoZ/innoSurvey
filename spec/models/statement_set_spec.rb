RSpec.describe StatementSet, type: :model do
  context 'Associations' do
    it { is_expected.to belong_to(:topic) }
    it { is_expected.to belong_to(:role) }
    it { is_expected.to have_many(:statements) }
  end
end
