Rails.application.routes.draw do
  root 'topics#show'

  get 'sign_in', to: 'sessions#create', as: :sign_in
  get 'sign_out', to: 'sessions#destroy', as: :sign_out
end
