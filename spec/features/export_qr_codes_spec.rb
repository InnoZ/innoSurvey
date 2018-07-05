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

  scenario 'can export qr codes' do
    visit surveys_path
    click_on 'Export QR codes'
    fill_in "survey_roles_#{@role.id}_iterations", with: 3
    attach_file("survey_roles_#{@role.id}_layout_front","spec/support/images/dummy_qr_layout_front.svg")
    click_on 'Export'
  end
end
