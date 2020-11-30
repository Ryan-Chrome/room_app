class DirectMessage < ApplicationRecord
  belongs_to :user
  belongs_to :room

  after_create_commit { DirectMessageBroadcastJob.perform_later self }

  validates :content, presence: true, length: {maximum: 200}
  validates :user_id, presence: true
  validates :room_id, presence: true
end
