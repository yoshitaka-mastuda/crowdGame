class EvaluationController < ApplicationController
  def index

  end

  def new
    @tweet = Tweet.order(:tweet_id => :desc).first
  end

end
