class UserBehaviorController < ApplicationController
  def click
    session[:behavior].push([params[:state].to_i, Time.now])
    render json: ''
  end
end
