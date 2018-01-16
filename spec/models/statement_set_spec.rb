RSpec.describe StatementSet, type: :model do
  context 'Associations' do
    it { is_expected.to belong_to(:topic) }
    it { is_expected.to belong_to(:role) }
    it { is_expected.to have_many(:statements) }
  end

  context "Attributes" do
    it { is_expected.to respond_to(:to_json) }
  end

  context 'Instance methods' do
    it 'is expected to serialize do JSON properly' do
      statement_set = create :statement_set

      expectation = {
        id: statement_set.id,
        role_id: statement_set.role.id,
        topic_id: statement_set.topic.id,
        statements: statement_set.statements.map(&:to_json)
      }.to_json

      expect(statement_set.to_json).to eq expectation
    end
  end
end
