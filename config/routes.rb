Rails.application.routes.draw do
  if ActiveRecord::Base.connection.table_exists?('surveys') && Survey.find_by(name: 'mFUND')
    root to: 'surveys#ident', id: Survey.find_by(name: 'mFUND').id
  else
    root 'surveys#index'
  end

  # ANSWERS
  post '/answers', to: 'answers#answer_question_set'

  # USER SESSIONS
  get 'login', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create', as: :sign_in
  get 'sign_out', to: 'sessions#destroy', as: :sign_out

  # SURVEY
  scope 'surveys' do
    get '', to: 'surveys#index', as: :surveys
    get '/:id/setup_qr_codes_export', to: 'surveys#setup_qr_codes_export', as: :setup_qr_codes_export
    post '/:id/export_qr_codes', to: 'surveys#export', as: :export_qr_codes
    get '/:id/ident', to: 'surveys#ident', as: :survey_ident
  end

  # STATIONS
  get 'stations/show/:id', to: 'stations#show'
  get '/stations/:id/content', to: 'stations#content', as: :station_content

  # TOPICS
  get '/topics/:id', to: 'topics#ident', as: :topic_ident
  get '/topics/finished/:uuid', to: 'topics#answered_topics_by_user'

  resources :surveys
  resources :stations, shallow: true do
    resources :topics
  end
  resources :statement_sets, shallow: true do
    resources :statements do
      resources :choices
    end
  end
end
