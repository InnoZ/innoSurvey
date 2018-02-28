RSpec.describe Statement, type: :model do
  context "Attributes" do
    it { is_expected.to respond_to(:text) }
    it { is_expected.to respond_to(:style) }
    it { is_expected.to respond_to(:to_json) }
  end

  context 'Instance methods' do
    it 'is expected to serialize do JSON properly' do
      statement = create :statement
      choices = create_list :choice, 2, statement: statement

      expectation = {
        id: statement.id,
        style: statement.style,
        text: statement.text,
        choices: statement.choices.map(&:to_json)
      }

      expect(statement.to_json).to eq expectation
    end
  end

  context "Associations" do
    it { is_expected.to(belong_to(:statement_set)) }

    it 'destroys associated choice and answer on destroy' do
      create_choice_stack
      statement = Statement.first
      create_list :answer, 2, statement: statement, selected_choices: statement.choices.pluck(:id), uuid: '123xy'

      expect { statement.destroy }.to change( Answer, :count).by(-2).and change( Choice, :count).by(-3)
    end
  end
end
