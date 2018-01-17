RSpec.describe StationsController, type: :controller do
  context 'GET #show' do
    before do
      @station = create :station

      get :show, params: { survey_name: @station.survey.name_url_safe, id: @station.id }, xhr: true
    end

    it 'populates correct instance variables' do
      expect(assigns(:survey)).to eq @station.survey
      expect(assigns(:station)).to eq @station
    end

    it 'Shall respond to query with proper JSON' do
      expect(response.body).to eq @station.to_json.to_json
    end
  end
end
