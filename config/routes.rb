Rails.application.routes.draw do
  if Survey.find_by(name: 'MFund')
    root to: 'surveys#ident', id: Survey.find_by(name: 'MFund').id
  else
    root 'surveys#index'
  end

  # STATIONS
  get 'stations/show/:id', to: 'stations#show'

  # ANSWERS
  post '/answers', to: 'answers#answer_question_set'

  # USER SESSIONS
  get 'login', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create', as: :sign_in
  get 'sign_out', to: 'sessions#destroy', as: :sign_out

  # TOPICS
  get '/topics/:id', to: 'topics#ident', as: :topic_ident
  get '/topics/finished/:uuid', to: 'topics#answered_topics_by_user'

  # SURVEY
  get '/surveys', to: 'surveys#index', as: :surveys
  get '/surveys/:id', to: 'surveys#ident', as: :survey_ident
  get '/surveys/:id/answers', to: 'surveys#answers', as: :survey_answers
end
