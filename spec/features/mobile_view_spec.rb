feature 'Mobile view', :js do
  before do
    @survey = create(:survey)
    @station = create(:station, survey: @survey)
    @topic_1 = create(:topic, station: @station, name: 'First topic')
    @topic_2 = create(:topic, station: @station,name: 'Second topic')
    @role = create(:role, survey: @survey, name: 'Tester')
    @statement_set = create(:statement_set, role: @role, topic: @topic_1)
    @statement_1 = create(:statement, statement_set: @statement_set, text: 'First question')
    3.times { |i| create(:choice, statement: @statement_1, text: "Sample answer #{i}") }
    @statement_2 = create(:statement, statement_set: @statement_set, text: 'Second question')
    3.times { |i| create(:choice, statement: @statement_2, text: "Sample answer #{i}") }

    visit survey_ident_path(@survey.id)
  end

  scenario 'includes working react app' do
    select_role_via_qr_code_scan
    select_first_topic
    answer_questions
    see_first_topic_disabled
    visit_again_and_scan_invalid_role_qr
    select_first_topic
    see_error_message
  end

  def visit_again_and_scan_invalid_role_qr
    visit survey_ident_path(@survey.id)
    scan(uuid: '123xy', role_id: '666')
    expect(page).to have_content('')
  end

  def select_role_via_qr_code_scan
    scan(uuid: '123xy', role_id: '1')
  end

  def see_error_message
    expect(page).to have_content('Hier gibt es keine Fragen für deine Rolle!')
  end

  def select_first_topic
    find('.button', text: 'First topic').trigger('click')
  end

  def answer_questions
    select_answer('Sample answer 0')
    click_on('weiter')
    select_answer('Sample answer 1')
    click_on('Absenden')
  end

  def select_answer(text)
    find('.choice', text: "#{text}").trigger('click')
  end

  def see_first_topic_disabled
    expect(page).to have_css('.button.disabled', text: 'First topic')
    expect(page).to have_css('.button', text: 'Second topic')
  end

  def scan(uuid:, role_id:)
    # since qr scan cannot be tested, it is faked by hidden form
    # see related function in scanner react component
    find('input#uuid-test-input', visible: false).set(uuid)
    find('input#role-id-test-input', visible: false).set(role_id)
    find('#send-fake-qr', visible: false).trigger('click')
  end
end