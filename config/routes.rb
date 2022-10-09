Rails.application.routes.draw do
  root 'static_pages#landing_page'
  get 'pricing', to: 'static_pages#pricing'
  get 'terms', to: 'static_pages#terms'
  get 'privacy', to: 'static_pages#privacy'

  get 'authorize', to: "instagram#authorize"
  get 'callback', to: "instagram#callback"
  get 'me', to: "instagram#me"
  get 'me/media', to: "instagram#media"
end
