class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
# this is used to order user.microposts from newest to oldest (order: table.column)
  default_scope order: 'microposts.created_at DESC'

  # class method, not an instance method
  def self.from_users_followed_by(user)
    # followed_user_ids is a shortcut for followed_users.map(&:id)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          { user_id: user.id })
          # since the hash is the last argument, the {} can be ommitted
  end
end
