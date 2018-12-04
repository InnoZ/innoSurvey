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

  context 'GET #gen_uuid' do
    it 'can receive valid UUID and token' do
      get :gen_uuid

      ret_hash = JSON.parse response.body
      expect(ret_hash["token"]).not_to be nil
      expect(ret_hash["uuid"]).not_to be nil
      expect(ret_hash["uuid"].encrypt).to eq ret_hash["token"]
    end
  end
end
