Rails.application.routes.draw do
  root 'topics#show'

  # TOPICS
  get '/:survey_name/:station_name/:id', to: 'topics#show'

  # USER SESSIONS
  get 'sign_in', to: 'sessions#create', as: :sign_in
  get 'sign_out', to: 'sessions#destroy', as: :sign_out
end
