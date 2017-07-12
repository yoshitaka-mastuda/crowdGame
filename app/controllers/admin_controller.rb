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
    auto_tweet_1 = Tweet.find_by_sql(['SELECT t.* FROM tweets t LEFT OUTER JOIN votes v ON t.tweet_id = v.tweet_id WHERE v.user_id = :user AND v.evaluation = 1 AND t.user_id = 99999', {user: params[:user_id]}]).count
    auto_tweet_0 = Tweet.find_by_sql(['SELECT t.* FROM tweets t LEFT OUTER JOIN votes v ON t.tweet_id = v.tweet_id WHERE v.user_id = :user AND v.evaluation = 0 AND t.user_id = 99999', {user: params[:user_id]}]).count
    manual_tweet_1 = Tweet.find_by_sql(['SELECT t.* FROM tweets t LEFT OUTER JOIN votes v ON t.tweet_id = v.tweet_id WHERE v.user_id = :user AND v.evaluation = 1 AND t.user_id != 99999', {user: params[:user_id]}]).count
    manual_tweet_0 = Tweet.find_by_sql(['SELECT t.* FROM tweets t LEFT OUTER JOIN votes v ON t.tweet_id = v.tweet_id WHERE v.user_id = :user AND v.evaluation = 0 AND t.user_id != 99999', {user: params[:user_id]}]).count
    @accept_rate = (manual_tweet_1.to_f + auto_tweet_1.to_f) / (manual_tweet_1.to_f + manual_tweet_0.to_f + auto_tweet_0.to_f + auto_tweet_1.to_f) * 100.0
    @manual_accept_rate = manual_tweet_1.to_f / (manual_tweet_1.to_f + manual_tweet_0.to_f) * 100.0
    @auto_reject_rate = auto_tweet_0.to_f / (auto_tweet_0.to_f + auto_tweet_1.to_f) * 100.0
  end

  def pay
    @user = User.find(params[:user])
    @user.payment = params[:pay]
    @user.memo = params[:memo]
    @user.save
  end

  def tweet
    @manual_accept = Tweet.find_by_sql(['SELECT t.* FROM tweets t  WHERE t.accept = 1 AND t.auto_flag = 0 ORDER BY t.updated_at DESC'])
    @manual_reject = Tweet.find_by_sql(['SELECT t.* FROM tweets t WHERE t.reject = 1 AND t.auto_flag = 0 ORDER BY t.updated_at DESC'])
    @manual_pending = Tweet.find_by_sql(['SELECT t.* FROM tweets t WHERE t.pending = 1 AND t.auto_flag = 0 ORDER BY t.votes_count DESC'])
    @auto_accept = Tweet.find_by_sql(['SELECT t.* FROM tweets t  WHERE t.accept = 1 AND t.auto_flag = 1 ORDER BY t.updated_at DESC'])
    @auto_reject = Tweet.find_by_sql(['SELECT t.* FROM tweets t WHERE t.reject = 1 AND t.auto_flag = 1 ORDER BY t.updated_at DESC'])
    @auto_pending = Tweet.find_by_sql(['SELECT t.* FROM tweets t WHERE t.pending = 1 AND t.auto_flag = 1 ORDER BY t.votes_count DESC'])
  end

  def reason
    @tweet = Tweet.where(:tweet_id => params[:t_id]).first
    @reason = Vote.where(:tweet_id => params[:t_id], :evaluation => 0)
  end

  def message
    @reason = Vote.where(:evaluation => 0).order('id DESC')
  end

  def tweet_url
    url  = 'https://twitter.com/statuses/' + params[:tweet_id]
    redirect_to(url)
  end

  private
    def confirm_admin_user!
      redirect_to root_path unless current_user.admin?
    end
end
