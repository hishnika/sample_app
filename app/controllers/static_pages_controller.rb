class StaticPagesController < ApplicationController
  def home
    if signed_in?
      # when you have an association, never do Micropost.new, always work
      # through the association (unlike '@user = User.new' in users_controller)
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
