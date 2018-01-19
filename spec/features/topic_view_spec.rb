feature 'Topic view', :js do
  before do
    @survey = create(:survey)
    @station = create(:station, survey: @survey)
    @topic = create(:topic, station: @station)
    @role = create(:role, survey: @survey, name: 'Tester')
    @statement_set = create(:statement_set, role: @role, topic: @topic)
    @statement_1 = create(:statement, statement_set: @statement_set, text: 'First question')
    2.times { |i| create(:choice, statement: @statement_1, text: "Sample answer #{i}") }
    @statement_2 = create(:statement, statement_set: @statement_set, text: 'Second question')
    3.times { |i| create(:choice, statement: @statement_2, text: "Sample answer #{i}") }

    visit topic_path(
      survey_name: @topic.survey.name_url_safe,
      station_id: @topic.station.id,
      id: @topic.id
    )
  end

  scenario 'includes working react app' do
    select_role_see_related_answers_and_select_first_answer
    do_not_show_send_button_unless_all_statements_answered
    select_other_question_and_see_related_answers
    select_and_highlight_one_choice
    send_question_set
  end

  def select_role_see_related_answers_and_select_first_answer
    find('.button', text: 'Tester').trigger('click')
    expect(page).to have_css('.question.active', text: 'First question')
    expect(page).to have_content('Sample answer', count: 2)
    select_answer 'Sample answer 0'
  end

  def do_not_show_send_button_unless_all_statements_answered
    expect(page).to_not have_css('.submit-button')
  end

  def select_other_question_and_see_related_answers
    find('.question', text: 'Second question').trigger('click')
    expect(page).to have_css('.question.active', text: 'Second question')
    expect(page).to have_content('Sample answer', count: 3)
  end

  def select_and_highlight_one_choice
    select_answer "Sample answer 1"
    expect(page).to have_css('.choice.active', text: 'Sample answer 1')
    expect(page).to have_css('.choice:not(.active)', count: 2)
  end

  def select_answer(text)
    find('.choice', text: "#{text}").trigger('click')
  end

  def send_question_set
    find('.submit-button').trigger('click')
    expect(page).to have_content('gespeichert')
  end
end
