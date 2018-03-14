Rails.application.routes.draw do
  root 'surveys#index'

  # STATIONS
  get 'stations/show/:id', to: 'stations#show'

  # ANSWERS
  post '/answers', to: 'answers#answer_question_set'

  # USER SESSIONS
  get 'sign_in', to: 'sessions#create', as: :sign_in
  get 'sign_out', to: 'sessions#destroy', as: :sign_out

  # TOPICS
  get '/topics/:id', to: 'topics#show', as: :topic
  get '/topics/finished/:id', to: 'topics#answered_topics_by_user'

  # PARTICIPANT
  get 'ident', to: 'participant#ident', as: :ident

end
