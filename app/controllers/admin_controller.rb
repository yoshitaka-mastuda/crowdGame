class AdminController < ApplicationController
  before_action :confirm_admin_user!
  def index

  end

  def user_list
    @users = User.all.includes(:tweets).order(:username)

    @users.each do |u|
      u.accept_count = Tweet.where(:user_id => u.id, :accept => true).count
      u.pending_count = Tweet.where(:user_id => u.id, :pending => true).count
      u.total_count = u.accept_count + u.evaluation_count
      u.save
    end
  end

  def user_show
    @user = User.find(params[:user_id])
    @accept = Tweet.find_by_sql(['SELECT t.* FROM tweets t LEFT OUTER JOIN votes v ON t.tweet_id = v.tweet_id WHERE v.user_id = :user AND v.evaluation = 1', {user: params[:user_id]}])
    @reject = Tweet.find_by_sql(['SELECT t.* FROM tweets t LEFT OUTER JOIN votes v ON t.tweet_id = v.tweet_id WHERE v.user_id = :user AND v.evaluation = 0', {user: params[:user_id]}])
    @accept_rate = 'x'
    @reject_rate = 'y'
  end

  def pay
    @user = User.find(params[:user])
    @user.payment = params[:pay]
    @user.memo = params[:memo]
    @user.save
  end

  private
    def confirm_admin_user!
      redirect_to root_path unless current_user.admin?
    end
end
