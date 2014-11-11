class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  # unlike micropost.rb, we can't say :user here, so it can't infer 
  # which class to use - we have to specify the class manually
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :followed_id, presence: true
  validates :follower_id, presence: true
end
