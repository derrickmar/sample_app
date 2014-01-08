class StaticPagesController < ApplicationController
#the actions is where you define the instance variables as well as the
  #action itself

  def home
    if signed_in?
      @micropost = current_user.microposts.build
      # takes the current_user and calls the method feed defined in
      # user.rb. Now, @feed_items is basically an array of all the
      # microposts of that user.
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
