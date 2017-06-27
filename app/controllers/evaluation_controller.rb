class EvaluationController < ApplicationController
  def index

  end

  def new
    @tweet = Tweet.offset( rand(Tweet.count) ).first
  end

  def create
    tweet_id = params[:tweet][:tweet_id]
    v = Vote.create(user_id: current_user.id, tweet_id: tweet_id, evaluation: params[:evaluation], message: params[:messega], category_id: params[:category])
    Click.where(user_id: current_user.id, tweet_id: tweet_id).each do |c|
      c.update_column(:vote_id , v.id)
      c.save
    end
    flash[:notice] = '作業結果を登録しました。次のツイートを評価してください。'
    redirect_to :action => 'new'
  end

end

