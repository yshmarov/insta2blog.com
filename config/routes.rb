Rails.application.routes.draw do
  root 'static_pages#landing_page'
  get 'pricing', to: 'static_pages#pricing'
  get 'terms', to: 'static_pages#terms'
  get 'privacy', to: 'static_pages#privacy'

  get 'instagram/authorize', to: "instagram#authorize"
  get 'instagram/callback', to: "instagram#callback"

  delete "logout", to: "sessions#logout", as: :logout

  get 'u/:id', to: 'insta_users#show', as: :insta_user
  get 'u', to: 'insta_users#index', as: :insta_users
  get 'u/:id/p', to: 'insta_posts#index', as: :insta_user_posts
  post 'u/:id/p/import', to: 'insta_posts#import', as: :import_insta_user_posts
  get 'u/:id/p/:post_id', to: 'insta_posts#show', as: :insta_user_post
end
