class AdminController < ApplicationController
  before_action :confirm_admin_user!
  def index

  end

  def user_list
    @users = User.all.includes(:tweets).order(total_point: :desc, username: :asc)
    @users.each do |u|
      u.accept_count = Tweet.where(:user_id => u.id, :accept => true).count
      u.pending_count = Tweet.where(:user_id => u.id, :pending => true).count
      u.total_count = u.accept_count + u.evaluation_count + u.evaluation_count2 + u.evaluation_count3
      u.accept_point = u.accept_count * 5 + u.pending_count + u.reject_count
      u.evaluation_point = u.evaluation_count*1 + u.evaluation_count2*1 + u.evaluation_count3*1
      u.total_point = u.accept_point + u.evaluation_point
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
    @ranking = User.all.order('total_point DESC').select("id").pluck(:id).find_index(params[:user_id].to_i) + 1
  end

  def pay
    @user = User.find(params[:user])
    @user.memo = params[:memo]
    @user.save
  end

  def pay_create
    @user = User.where(:username => params[:name]).first(1)[0]
    @pay_point = params[:point]
    Payment.create(user_id: @user.id, point: @pay_point)
    @user.payment = Payment.where(:user_id => @user.id).sum(:point)
    @user.save
    redirect_to :action => 'index'
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

  def category_index
    @accept_tweet = Tweet.where(:accept => 1)
    @category_0 = VoteCategory.find_by_sql(['SELECT c.*, v.*, t.* FROM vote_categories c INNER JOIN votes v ON c.vote_id = v.id INNER JOIN tweets t ON v.tweet_id = t.tweet_id WHERE c.category_id = 0']).uniq {|vote| vote.tweet_id}
    @category_1 = VoteCategory.find_by_sql(['SELECT c.*, v.*, t.* FROM vote_categories c INNER JOIN votes v ON c.vote_id = v.id INNER JOIN tweets t ON v.tweet_id = t.tweet_id WHERE c.category_id = 1']).uniq {|vote| vote.tweet_id}
    @category_2 = VoteCategory.find_by_sql(['SELECT c.*, v.*, t.* FROM vote_categories c INNER JOIN votes v ON c.vote_id = v.id INNER JOIN tweets t ON v.tweet_id = t.tweet_id WHERE c.category_id = 2']).uniq {|vote| vote.tweet_id}
    @category_3 = VoteCategory.find_by_sql(['SELECT c.*, v.*, t.* FROM vote_categories c INNER JOIN votes v ON c.vote_id = v.id INNER JOIN tweets t ON v.tweet_id = t.tweet_id WHERE c.category_id = 3']).uniq {|vote| vote.tweet_id}
    @category_4 = VoteCategory.find_by_sql(['SELECT c.*, v.*, t.* FROM vote_categories c INNER JOIN votes v ON c.vote_id = v.id INNER JOIN tweets t ON v.tweet_id = t.tweet_id WHERE c.category_id = 4']).uniq {|vote| vote.tweet_id}
    @category_5 = VoteCategory.find_by_sql(['SELECT c.*, v.*, t.* FROM vote_categories c INNER JOIN votes v ON c.vote_id = v.id INNER JOIN tweets t ON v.tweet_id = t.tweet_id WHERE c.category_id = 5']).uniq {|vote| vote.tweet_id}
    @category_6 = VoteCategory.find_by_sql(['SELECT c.*, v.*, t.* FROM vote_categories c INNER JOIN votes v ON c.vote_id = v.id INNER JOIN tweets t ON v.tweet_id = t.tweet_id WHERE c.category_id = 6']).uniq {|vote| vote.tweet_id}
    @category_7 = VoteCategory.find_by_sql(['SELECT c.*, v.*, t.* FROM vote_categories c INNER JOIN votes v ON c.vote_id = v.id INNER JOIN tweets t ON v.tweet_id = t.tweet_id WHERE c.category_id = 7']).uniq {|vote| vote.tweet_id}
  end

  private
    def confirm_admin_user!
      redirect_to root_path unless current_user.admin?
    end
end
