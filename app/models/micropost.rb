class Micropost < ActiveRecord::Base
  belongs_to :user
  # this creates the correct order from newest to oldest instead of
  # the default which is by id.
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
end
