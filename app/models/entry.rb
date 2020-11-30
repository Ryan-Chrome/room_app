class Entry < ApplicationRecord

  generate_public_uid generator: PublicUid::Generators::HexStringSecureRandom.new(20)

  belongs_to :user
  belongs_to :room

  validates :user_id, presence: true
  validates :room_id, presence: true

  def to_param
    public_uid
  end
end
