class RelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    # respond_to allows the use of ajax
    respond_to do |format|
      format.html { redirect_to @user }
      # this by default calls a js file named after the action (create.js.erb)
      format.js
    end
    
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end