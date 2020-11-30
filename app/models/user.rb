class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  generate_public_uid generator: PublicUid::Generators::NumberSecureRandom.new

  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id', dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :user

  has_many :entries, dependent: :destroy
  has_many :direct_messages, dependent: :destroy
  has_many :rooms, through: :entries

  has_one_attached :image

  validates :name, presence: true, length: {maximum: 10}


  def follow(other_user)
    unless self == other_user
      self.relationships.create(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def friend?(other_user)
    other_user.followings.include?(self) && self.followings.include?(other_user)
  end

  def approval?(other_user)
    other_user.followings.include?(self) && !self.followings.include?(other_user)
  end

  def request?(other_user)
    self.followings.include?(other_user) && !other_user.followings.include?(self)
  end
end
