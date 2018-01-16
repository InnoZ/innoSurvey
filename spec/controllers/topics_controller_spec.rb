RSpec.describe TopicsController, type: :controller do
  context 'GET #show' do
    before do
      @topic = create :topic

      get :show,  params: { survey_name: @topic.survey.name_url_safe, station_id: @topic.station.id, id: @topic.id }, xhr: true
    end

    it 'populates correct instance variables' do
      expect(assigns(:survey)).to eq @topic.survey
      expect(assigns(:station)).to eq @topic.station
    end

    it 'Shall respond to query with proper JSON' do
      expect(response.body).to eq @topic.to_json
    end
  end
end
