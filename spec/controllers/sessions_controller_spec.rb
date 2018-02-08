require 'rails_helper'

describe SessionsController do
  context 'GET #new' do
    it 'Responde with log_in' do
      get :new

      expect(response.status).to eq(200)
    end
  end
  context 'POST #create' do
    it 'Can login' do
      user = create :user

      post :create, params: {
        sessions: { email: user.email, password: 'secret' }
      }


      expect(session[:user_id]).to eq(user.id)
    end
  end

  context 'DESTROY #destroy' do
    it 'Can logout' do
      user = create :user
      session[:user_id] = user.id

      get :destroy

      expect(session[:user_id]).to be_nil
    end
  end
end
