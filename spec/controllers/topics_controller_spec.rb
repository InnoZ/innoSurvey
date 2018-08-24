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
      @role = create(:role)
      @topics = create_list(:topic, 10)
      @answered_topics = []
      @statement_sets = []
      @statements = []
      @user_id          = 'test42424242'

      @topics.each do |t|
        statement_set = create :statement_set, topic_id: t.id, role_id: @role.id
        @statement_sets.append statement_set
        statements = create_list(:statement, 10, statement_set_id: statement_set.id)
        statements.map{ |s| create_list(:choice, 4, statement_id: s.id) }
        @statements.push statements
      end

      (0..5).each do |i|
        @statements[i].each do |s|
          choices = Choice.where(statement_id: s.id)
          selected_choice = "[#{choices[rand(0..choices.count-1)].id}]"
          create :answer, statement_id: s.id, selected_choices: selected_choice, uuid: @user_id
        end
        @answered_topics.append(@topics[i].id)
      end
    end
    it 'Shall return all finished topics' do
      get :answered_topics_by_user, { params: { uuid: @user_id} }
      answered_topics = JSON.parse(response.body)
      expect(answered_topics.count).to eq(6)
      expect(answered_topics).to eq(@answered_topics)
    end
  end
end
