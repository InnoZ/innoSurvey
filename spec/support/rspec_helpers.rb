module RSpecHelpers
  def create_choice_stack
    @survey = create :survey
    @role = create :role, survey: @survey
    @station = create :station, survey: @survey
    @topics = create :topic, station: @station
    @statement_set = create :statement_set, topic: @topics, role: @role
    @statements = create_list :statement, 3, statement_set: @statement_set
    @statements.each do |statement|
      create_list :choice, 3, statement: statement
      create_list :answer, 2, statement: statement
    end
  end
end
