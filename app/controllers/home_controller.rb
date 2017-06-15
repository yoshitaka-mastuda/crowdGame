class HomeController < ApplicationController
  def index
    @tweets = Tweet.includes(:twitter_user)
  end
end
