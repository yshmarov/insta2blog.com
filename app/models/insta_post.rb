class InstaPost < ApplicationRecord
  belongs_to :insta_user
  validates :remote_id, presence: true, uniqueness: true
end
