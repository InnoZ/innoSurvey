RSpec.describe TopicsController, type: :controller do
  context 'GET #ident' do
    before do
      @topic = create :topic
    end

    def request(format)
      get :ident, { params: {
        survey_name: @topic.survey.name_url_safe, station_id: @topic.station.id, id: @topic.id
      }, xhr: true, format: format }
    end

    it 'Shall respond to query with proper JSON' do
      request('json')
      expect(response.body).to eq @topic.to_json.to_json
    end
  end
end
