class UserBehaviorController < ApplicationController
  def click
    Click.create(user_id: current_user.id, tweet_id: params[:tweet_id].to_i, state: params[:state].to_i)
    render json: ''
  end
end
