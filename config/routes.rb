Rails.application.routes.draw do
  root 'topics#show'

  # TOPICS
  get '/:survey_name/:station_id/:id', to: 'topics#show'

  # STATIONS
  get 'stations/show/:id', to: 'stations#show'

  # ANSWERS
  post '/answers', to: 'answers#answer_question_set'

  # USER SESSIONS
  get 'sign_in', to: 'sessions#create', as: :sign_in
  get 'sign_out', to: 'sessions#destroy', as: :sign_out
end
