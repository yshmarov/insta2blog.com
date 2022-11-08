Rails.application.routes.draw do
  root 'static_pages#landing_page'
  get 'pricing', to: 'static_pages#pricing'
  get 'terms', to: 'static_pages#terms'
  get 'privacy', to: 'static_pages#privacy'

  # passwordless_for :users
  passwordless_for :users, at: '/', as: :auth

  get 'instagram/authorize', to: "instagram#authorize"
  get 'instagram/callback', to: "instagram#callback"
  get 'instagram/deauthorize', to: "instagram#deauthorize"
  get 'instagram/delete', to: "instagram#delete"

  get 'u', to: 'insta_users#index', as: :insta_users
  get 'u/:id', to: 'insta_users#show', as: :insta_user
  get 'u/:id/p', to: 'insta_posts#index', as: :insta_user_posts
  get 'u/:id/p/:post_id', to: 'insta_posts#show', as: :insta_user_post
  post 'u/:id/p/import', to: 'insta_posts#import', as: :import_insta_user_posts
end
