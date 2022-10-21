Rails.application.routes.draw do
  root 'static_pages#landing_page'
  get 'pricing', to: 'static_pages#pricing'
  get 'terms', to: 'static_pages#terms'
  get 'privacy', to: 'static_pages#privacy'

  get 'instagram/authorize', to: "instagram#authorize"
  get 'instagram/callback', to: "instagram#callback"

  delete "logout", to: "sessions#logout", as: :logout

  get 'insta_users/:id', to: 'insta_users#show', as: :insta_user
  get 'insta_users', to: 'insta_users#index', as: :insta_users
  get 'insta_users/:id/posts', to: 'insta_users#posts', as: :insta_user_posts
end
