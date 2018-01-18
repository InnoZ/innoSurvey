module RSpecHelpers
  def create_choice_stack
    @survey = create :survey
    @role = create :role, survey: @survey
    @station = create :station, survey: @survey
    @topic = create :topic, station: @station
    @statement_set = create :statement_set, topic: @topic, role: @role
    @statements = create_list :statement, 3, statement_set: @statement_set
    @statements.each do |statement|
      create_list :choice, 3, statement: statement
    end
  end

  def generate_valid_answer_params
    create_choice_stack
    choices0_ids = @statements[0].choices.pluck(:id)
    choices1_ids = @statements[1].choices.pluck(:id)
    choices2_ids = @statements[2].choices.pluck(:id)

    { answers: [
      { statement_id: @statements[0].id, selected_choices: choices0_ids.slice(0, 1) },
      { statement_id: @statements[1].id, selected_choices: choices1_ids.slice(1, 1) },
      { statement_id: @statements[2].id, selected_choices: choices2_ids.slice(1, 2) }, ]
    }
  end
end
