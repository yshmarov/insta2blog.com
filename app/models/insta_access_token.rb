class InstaAccessToken < ApplicationRecord
  belongs_to :insta_user, optional: true
  # valid:boolean, default: true
end
