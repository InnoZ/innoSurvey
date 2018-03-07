feature 'Exhibition view', :js do
  before do
    @survey = create(:survey)
    @station = create(:station, survey: @survey)
    @topic = create(:topic, station: @station)
    @role = create(:role, survey: @survey, name: 'Tester')
    @statement_set = create(:statement_set, role: @role, topic: @topic)
    @statement_1 = create(:statement, statement_set: @statement_set, text: 'First question')
    3.times { |i| create(:choice, statement: @statement_1, text: "Sample answer #{i}") }
    @statement_2 = create(:statement, statement_set: @statement_set, text: 'Second question')
    3.times { |i| create(:choice, statement: @statement_2, text: "Sample answer #{i}") }

    visit topic_path(
      survey_name: @topic.survey.name_url_safe,
      station_id: @topic.station.id,
      id: @topic.id
    )
  end

  scenario 'includes working react app' do
    select_role_via_qr_code_scan
    select_and_highlight_one_choice
    do_not_show_send_button_unless_all_statements_answered
    select_other_question_and_see_related_answers
    select_and_highlight_one_choice
    send_question_set_and_see_qr_scan_view
    scan_code_with_invalid_role_id
  end

  def select_role_via_qr_code_scan
    scan(uuid: '123xy', role_id: '1')
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

  def send_question_set_and_see_qr_scan_view
    find('.submit-button').trigger('click')
    expect(page).to have_content('gespeichert')
    expect(page).to have_content('Scanne deinen QR-Code')
  end

  def scan_code_with_invalid_role_id
    scan(uuid: '123xy', role_id: '666')
    expect(page).to have_content('Mit deinem QR-Code kann ich nichts anfangen')
  end

  def scan(uuid:, role_id:)
    # since qr scan cannot be tested, it is faked by hidden form
    # see related function in scanner react component
    find('input#uuid-test-input', visible: false).set(uuid)
    find('input#role-id-test-input', visible: false).set(role_id)
    find('#send-fake-qr', visible: false).trigger('click')
  end
end
