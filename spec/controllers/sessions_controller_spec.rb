require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  context 'GET #new' do
    it 'Responde with log_in' do
      get :new

      expect(response.status).to eq(200)
    end
  end
  context 'POST #create' do
    let(:user) { create :user }
    subject { post :create, params: { sessions: { email: user.email, password: 'secret' }}}

    it 'Can login with correct creds' do
      expect(subject).to redirect_to(surveys_path)
      expect(session[:user_id]).to eq(user.id)
    end
  end

  context 'DESTROY #destroy' do
    it 'Can logout' do
      user = create :user
      session[:user_id] = user.id

      get :destroy
      expect(response).to redirect_to(root_path)
      expect(session[:user_id]).to be_nil
    end
  end
end
