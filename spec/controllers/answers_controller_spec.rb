RSpec.describe AnswersController, type: :controller do
  context 'POST #answer_question_set' do
    it 'creates valid answer from POSTed JSON' do
      expect {
        post :answer_question_set, params: { answers: generate_valid_answer }, xhr: true
      }.to change(Answer, :count).by(3)
    end
  end
end
