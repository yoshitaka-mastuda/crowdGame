class EvaluationController < ApplicationController
  def index

  end

  def new
    @tweet = Tweet.order(:tweet_id => :desc).first
  end

  def create
    (params[:commit].to_s == 'はい') ? evaluation = 1 : evaluation = 0
    tweet_id = params[:tweet][:tweet_id]
    v = Vote.create(user_id: current_user.id, tweet_id: tweet_id, evaluation: evaluation)
    Click.where(user_id: current_user.id, tweet_id: tweet_id).each do |c|
      c.update_column(:vote_id , v.id)
      c.save
    end
  end

end
