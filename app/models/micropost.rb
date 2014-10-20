class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
# this is used to order user.microposts from newest to oldest (order: table.column)
  default_scope order: 'microposts.created_at DESC'
end
