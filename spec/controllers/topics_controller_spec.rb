RSpec.describe TopicsController, type: :controller do
  context 'GET #show' do
    before do
      @topic = create :topic
    end

    it 'Shall respond to query with proper JSON' do
      get :show,  params: { survey_name: @topic.survey.name, station_name: @topic.station.name, id: @topic.id }, xhr: true

      expect(response.body).to eq @topic.to_json
    end
  end
end
