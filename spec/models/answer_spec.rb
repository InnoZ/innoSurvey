RSpec.describe Answer, type: :model do
  context "Attributes" do
    it "should respond to result" do 
      expect(Answer.new).to respond_to(:selected_choices)
    end
  end

  context "Associations" do
    it { is_expected.to(belong_to(:statement)) }
  end

  context 'Instance methods' do
    it 'can return selected statement choices' do
      statement = create :statement
      choices = create_list :choice, 3, statement: statement
      answer = create :answer, statement: statement, selected_choices: "#{choices.pluck(:id)}"

      expect(answer.selected_choices_inst).to eq choices
    end
  end
end
