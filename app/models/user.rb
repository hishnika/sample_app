class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  # never include :admin in attr_accessible because a user can use it in POST 
  # instead, use user.toggle!(:admin) when creating a user in tests etc.
  # see "accessible attirbutes" test in user_spec
  has_secure_password
  # destroy microposts when user is deleted
  has_many :microposts, dependent: :destroy
  # foreign key is needed here because user_id maps to follower_id unlike microposts
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  # if source is left off, Rails would look for followed_user and follower_user in
  # realtionship.rb. The second sounds weird so source helps avoid those names
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", 
                                   class_name: "Relationship", 
                                   dependent: :destroy
  # no source needed since there is a follower_id but we keep it for symmetry
  has_many :followers, through: :reverse_relationships, source: :follower

  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\Z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  after_validation { self.errors.messages.delete(:password_digest) }

  def following?(other_user)
    # self.followed_users.include?(other_user) --my version
    self.relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    # self can be left off when we're not assigning to it
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def feed
    # The original proto-feed:
    # self.microposts or microposts, or self.id, or id it all works but this is better
    # Micropost.where("user_id = ?", id) 
    # never interpolate inside a query due to SQL injection

    # here we use a class method
    Micropost.from_users_followed_by(self)
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
