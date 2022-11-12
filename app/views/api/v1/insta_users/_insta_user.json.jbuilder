json.extract! insta_user, :id, :remote_id, :username, :account_type, :media_count, :slug, :created_at, :updated_at
json.api_url api_v1_insta_users_path(insta_user, format: :json)
json.url insta_user_posts_url(insta_user, format: :json)

json.media_url insta_user_posts_url(insta_user, format: :json)