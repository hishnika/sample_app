class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  # never include :admin in attr_accessible because a user can use it in POST 
  # instead, use user.toggle!(:admin) when creating a user in tests etc.
  # see "accessible attirbutes" test in user_spec
  has_secure_password
  # destroy microposts when user is deleted
  has_many :microposts, dependent: :destroy

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

  def feed
    # This is only a proto-feed
    # self.microposts or microposts, or self.id, or id it all works but this is better
    Micropost.where("user_id = ?", id) 
    # never interpolate inside a query due to SQL injection
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
