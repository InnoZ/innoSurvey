require 'encrypt_decrypt'

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
  end

  scenario 'includes working react app' do
    visit topic_ident_path(@topic.id)

    select_role_via_qr_code_scan
    select_and_highlight_one_choice
    do_not_show_send_button_unless_all_statements_answered
    select_other_question_and_see_related_answers
    select_and_highlight_one_choice
    send_question_set_and_see_qr_scan_view

    select_role_via_qr_code_scan
    get_error_message_because_same_code
    scan_code_with_invalid_role_id_and_jump_back_to_initial_screen
  end

  scenario 'does not work without correct token within qr code' do
    visit topic_ident_path(@topic.id)

    scan_wrong_token
    select_and_highlight_one_choice
    do_not_show_send_button_unless_all_statements_answered
    select_other_question_and_see_related_answers
    select_and_highlight_one_choice
    send_question_set_and_do_not_save
  end

  scenario 'shows Scanner immediately and redirects to url if url is transmitted' do
    visit "topics/#{@topic.id}?url=#{root_path}"
    expect(page).to have_content('Scanne deinen QR-Code')
    sleep 11 # returns to given url after 10 seconds of inactivity
    expect(page).to have_content('Sample station')
  end

  def get_error_message_because_same_code
    expect(page).to have_content('Hier warst du schon')
    find('.question').trigger('click')
  end

  def select_role_via_qr_code_scan
    find('.question', text: 'Klicke hier, um die Umfrage zu starten').trigger('click')
    scan(uuid: '123xy', role_id: '1', token: '123xy'.encrypt)
  end

  def scan_wrong_token
    find('.question', text: 'Klicke hier, um die Umfrage zu starten').trigger('click')
    scan(uuid: '123xy', role_id: '1', token: 'wrong'.encrypt)
  end

  def do_not_show_send_button_unless_all_statements_answered
    expect(page).to_not have_css('.submit-button')
  end

  def select_other_question_and_see_related_answers
    find('.next-button').trigger('click')
    expect(page).to have_css('.question', text: 'Second question')
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
    click_on('Absenden')
    expect(page).to have_content('gespeichert')
    expect(page).to have_content('Klicke hier, um die Umfrage zu starten')
  end

  def send_question_set_and_do_not_save
    click_on('Absenden')
    sleep 1
    expect(page).to_not have_content('gespeichert')
  end

  def scan_code_with_invalid_role_id_and_jump_back_to_initial_screen
    scan(uuid: '123xy', role_id: '666', token: '123xy'.encrypt)
    expect(page).to have_content('Dein QR-Code passt nicht zu dieser Umfrage')
    expect(page).to have_content('Klicke hier, um die Umfrage zu starten')
  end

  def scan_code_with_wrong_token_and_do_not_save_answers
    find('.question', text: 'Klicke hier, um die Umfrage zu starten').trigger('click')
    scan(uuid: '123xy', role_id: '1', token: 'wrong'.encrypt)
    find('.next-button').trigger('click')
    click_on('Absenden')
    expect(page).to have_content('gespeichert')
    expect(page).to have_content('Klicke hier, um die Umfrage zu starten')
  end

  def scan(uuid:, role_id:, token:)
    # since qr scan cannot be tested, it is faked by hidden form
    # see related function in scanner react component
    find('input#uuid-test-input', visible: false).set(uuid)
    find('input#role-id-test-input', visible: false).set(role_id)
    find('input#token-test-input', visible: false).set(token)
    find('#send-fake-qr', visible: false).trigger('click')
  end
end
