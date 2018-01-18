feature 'Topic view', :js do
  before do
    @statement = create(:statement)
    visit topic_path(
      survey_name: @statement.topic.station.survey.name_url_safe,
      station_id: @statement.topic.station.id,
      id: @statement.topic.id
    )
  end

  scenario 'has role buttons directing to statement set' do
    find('.button', text: 'SampleRole').trigger('click')
    expect(page).to have_css('.question', text: 'I am a sample statement')
  end
end
