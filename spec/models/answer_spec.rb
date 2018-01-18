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

  context 'Validations' do
    before do
      create_choice_stack
      choices0_ids = @statements[0].choices.pluck(:id)
      choices1_ids = @statements[1].choices.pluck(:id)
      choices2_ids = @statements[2].choices.pluck(:id)

      @answers_hash = { answers: [
        { statement_id: @statements[0].id, selected_choices: choices0_ids.slice(0, 1) },
        { statement_id: @statements[1].id, selected_choices: choices1_ids.slice(1, 1) },
        { statement_id: @statements[2].id, selected_choices: choices2_ids.slice(1, 2) }, ]
      }
      @answer = @answers_hash[:answers].first
    end

    it 'can save valid answer' do
      expect { Answer.create(@answer) }.to change(Answer, :count).by(1)
    end

    context 'invalid answers' do
      it 'will not save answer with malformatted selected choices string' do
        @answer[:selected_choices] = "wrong format!"
        new_answer = Answer.new(@answer)

        expect(new_answer).not_to be_valid
      end

      it 'will not save answer with selected choices referring to non-existing statements' do
        @answer[:selected_choices] ="[9999]"
        new_answer = Answer.new(@answer)

        expect(new_answer).not_to be_valid
      end

      it 'will not save answer with selected choices referring to statements from different statements' do
        another_statement = create :statement, statement_set: @statement_set
        choice_for_another_statement = create :choice, statement: another_statement

        @answer[:selected_choices] << choice_for_another_statement.id
        new_answer = Answer.new(@answer)

        expect(new_answer).not_to be_valid
      end

      it 'will not save answer with no selected choices' do
        another_statement = create :statement, statement_set: @statement_set
        choice_for_another_statement = create :choice, statement: another_statement

        @answer[:selected_choices] = []
        new_answer = Answer.new(@answer)

        expect(new_answer).not_to be_valid
      end
    end
  end
end
