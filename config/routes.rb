Rails.application.routes.draw do
  GoodJob::Engine.middleware.use(Rack::Auth::Basic) do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(Rails.application.credentials.dig(:http_auth, :username), username) &&
      ActiveSupport::SecurityUtils.secure_compare(Rails.application.credentials.dig(:http_auth, :password), password)
  end
  mount GoodJob::Engine, at: "good_job"

  root 'static_pages#landing_page'
  get 'pricing', to: 'static_pages#pricing'
  get 'terms', to: 'static_pages#terms'
  get 'privacy', to: 'static_pages#privacy'

  passwordless_for :users, at: '/', as: :auth

  get 'me', to: 'users#show', as: :user

  get 'instagram/authorize', to: "instagram#authorize"
  get 'instagram/callback', to: "instagram#callback"
  get 'instagram/deauthorize', to: "instagram#deauthorize"
  get 'instagram/delete', to: "instagram#delete"

  get 'u', to: 'insta_users#index', as: :insta_users
  get 'u/:id', to: 'insta_users#show', as: :insta_user
  delete 'u/:id', to: 'insta_users#destroy', as: :delete_insta_user
  post 'u/:id/import', to: 'insta_users#import', as: :import_insta_user
  get 'u/:id/media_count', to: 'insta_users#media_count', as: :media_count_insta_user

  get 'u/:user_id/p', to: 'insta_posts#index', as: :insta_user_posts
  get 'u/:user_id/p/:id', to: 'insta_posts#show', as: :insta_user_post
end
