class Room < ApplicationRecord
  generate_public_uid generator: PublicUid::Generators::HexStringSecureRandom.new(20)

  has_many :entries, dependent: :destroy
  has_many :direct_messages, dependent: :destroy
  has_many :users, through: :entries

  validates :name, presence: true, length: { maximum: 10 }

  def to_param
    public_uid
  end
end
