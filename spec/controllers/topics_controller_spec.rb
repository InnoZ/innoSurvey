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
  context 'GET #by_user_answered_topics' do
    before do
      @roles = create_list(:role, 3)
      @topics = create_list(:topic, 3)
      @user_id          = 'test42424242'
      @another_user_id  = 'test12345678'

      @statement_set_0  = create :statement_sets, topic_id: @topics[0].id, role_id: @roles[0].id
      @statements0      = create_list(:statements, 10, statement_set_0.id)
      @answers0_user    = @statements0.map { |x| create :answer, statement_id: x.id, uuid: @user_id }
      binding.pry
      @statement_set_1  = create :statement_sets, topic_id: @topics[1].id, role_id: @roles[1].id
      @statements1      = create_list(:statements, 10, statement_set_1.id)
      @statement_set_2  = create :statement_sets, topic_id: @topics[2].id, role_id: @roles[2].id
      @statements2      = create_list(:statements, 10, statement_set_2.id)
      
    end
    def generate_answers(statements, user_id)
      answers = []

    end
    def request(user)
      get :by_user_answered_topics, { params: { id: user} }
    end 
    it 'Shall return all finished topics' do
      request(@user_id)
    end
  end
end
