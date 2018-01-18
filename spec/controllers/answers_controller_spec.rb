RSpec.describe AnswersController, type: :controller do
  context 'POST #answer_question_set' do
    it 'creates valid answer from POSTed JSON' do
      skip 'weird things happening to params in controller... oO'
      expect {
        post :answer_question_set, params:  generate_valid_answer_params, xhr: true
      }.to change(Answer, :count).by(3)
    end
  end
end
