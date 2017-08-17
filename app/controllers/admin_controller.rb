class AdminController < ApplicationController
  before_action :confirm_admin_user!
  def index

  end

  def user_list
    @users = User.where("total_point >= 100").includes(:tweets).order(total_point: :desc, username: :asc)
    @users.each do |u|
      u.accept_count = Tweet.where(:user_id => u.id, :accept => true).count
      u.pending_count = Tweet.where(:user_id => u.id, :pending => true).count
      u.total_count = u.accept_count + u.evaluation_count + u.evaluation_count2 + u.evaluation_count3 + u.evaluation_count4
      u.accept_point = u.accept_count * 5 + u.pending_count + u.reject_count
      u.evaluation_point = u.evaluation_count*1 + u.evaluation_count2*1 + u.evaluation_count3*1 + u.evaluation_count4*1
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
    @manual_accept = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t  WHERE t.accept = 1 AND t.auto_flag = 0 ORDER BY t.updated_at DESC']).count
    @manual_reject = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t WHERE t.reject = 1 AND t.auto_flag = 0 ORDER BY t.updated_at DESC']).count
    @manual_pending = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t WHERE t.pending = 1 AND t.auto_flag = 0 ORDER BY t.votes_count DESC']).count
    @auto_accept = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t  WHERE t.accept = 1 AND t.auto_flag = 1 ORDER BY t.updated_at DESC']).count
    @auto_reject = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t WHERE t.reject = 1 AND t.auto_flag = 1 ORDER BY t.updated_at DESC']).count
    @auto_pending = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t WHERE t.pending = 1 AND t.auto_flag = 1 ORDER BY t.votes_count DESC']).count

    @category_weather0 = Tweet.find_by_sql(['SELECT t.tweet_id, c.category_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=0 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=0']).count
    @category_crowd0 = Tweet.find_by_sql(['SELECT t.tweet_id, c.category_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=0 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=1']).count
    @category_scenery0 = Tweet.find_by_sql(['SELECT t.tweet_id, c.category_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=0 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=2']).count
    @category_trans0 = Tweet.find_by_sql(['SELECT t.tweet_id, c.category_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=0 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=3']).count
    @category_ivent0 = Tweet.find_by_sql(['SELECT t.tweet_id, c.category_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=0 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=4']).count
    @category_meal0 = Tweet.find_by_sql(['SELECT t.tweet_id, c.category_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=0 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=5']).count
    @category_spot0 = Tweet.find_by_sql(['SELECT t.tweet_id, c.category_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=0 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=6']).count
    @category_other0 = Tweet.find_by_sql(['SELECT t.tweet_id, c.category_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=0 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=7']).count
    @category_weather1 = Tweet.find_by_sql(['SELECT t.tweet_id, c.category_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=1 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=0']).count
    @category_crowd1 = Tweet.find_by_sql(['SELECT t.tweet_id, c.category_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=1 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=1']).count
    @category_scenery1 = Tweet.find_by_sql(['SELECT t.tweet_id, c.category_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=1 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=2']).count
    @category_trans1 = Tweet.find_by_sql(['SELECT t.tweet_id, c.category_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=1 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=3']).count
    @category_ivent1 = Tweet.find_by_sql(['SELECT t.tweet_id, c.category_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=1 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=4']).count
    @category_meal1 = Tweet.find_by_sql(['SELECT t.tweet_id, c.category_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=1 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=5']).count
    @category_spot1 = Tweet.find_by_sql(['SELECT t.tweet_id, c.category_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=1 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=6']).count
    @category_other1 = Tweet.find_by_sql(['SELECT t.tweet_id, c.category_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=1 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=7']).count
    @category_weather0_rate = (@category_weather0.to_f / @manual_accept.to_f).round(3)
    @category_crowd0_rate = (@category_crowd0.to_f / @manual_accept.to_f).round(3)
    @category_scenery0_rate = (@category_scenery0.to_f / @manual_accept.to_f).round(3)
    @category_trans0_rate = (@category_trans0.to_f / @manual_accept.to_f).round(3)
    @category_ivent0_rate = (@category_ivent0.to_f / @manual_accept.to_f).round(3)
    @category_meal0_rate = (@category_meal0.to_f / @manual_accept.to_f).round(3)
    @category_spot0_rate = (@category_spot0.to_f / @manual_accept.to_f).round(3)
    @category_other0_rate = (@category_other0.to_f / @manual_accept.to_f).round(3)
    @category_weather1_rate = (@category_weather1.to_f / @auto_accept.to_f).round(3)
    @category_crowd1_rate = (@category_weather1.to_f / @auto_accept.to_f).round(3)
    @category_scenery1_rate = (@category_scenery1.to_f / @auto_accept.to_f).round(3)
    @category_trans1_rate = (@category_trans1.to_f / @auto_accept.to_f).round(3)
    @category_ivent1_rate = (@category_ivent1.to_f / @auto_accept.to_f).round(3)
    @category_meal1_rate = (@category_meal1.to_f / @auto_accept.to_f).round(3)
    @category_spot1_rate = (@category_spot1.to_f / @auto_accept.to_f).round(3)
    @category_other1_rate = (@category_other1.to_f / @auto_accept.to_f).round(3)

    @reason_kyoto0 = Tweet.find_by_sql(['SELECT t.tweet_id, c.reason_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=0 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=0']).count
    @reason_sightseeing0 = Tweet.find_by_sql(['SELECT t.tweet_id, c.reason_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=0 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=1']).count
    @reason_scenery0 = Tweet.find_by_sql(['SELECT t.tweet_id, c.reason_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=0 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=2']).count
    @reason_old0 = Tweet.find_by_sql(['SELECT t.tweet_id, c.reason_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=0 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=3']).count
    @reason_bot0 = Tweet.find_by_sql(['SELECT t.tweet_id, c.reason_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=0 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=4']).count
    @reason_other0 = Tweet.find_by_sql(['SELECT t.tweet_id, c.reason_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=0 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=5']).count
    @reason_kyoto1 = Tweet.find_by_sql(['SELECT t.tweet_id, c.reason_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=1 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=0']).count
    @reason_sightseeing1 = Tweet.find_by_sql(['SELECT t.tweet_id, c.reason_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=1 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=1']).count
    @reason_scenery1 = Tweet.find_by_sql(['SELECT t.tweet_id, c.reason_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=1 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=2']).count
    @reason_old1 = Tweet.find_by_sql(['SELECT t.tweet_id, c.reason_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=1 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=3']).count
    @reason_bot1 = Tweet.find_by_sql(['SELECT t.tweet_id, c.reason_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=1 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=4']).count
    @reason_other1 = Tweet.find_by_sql(['SELECT t.tweet_id, c.reason_id, count(*) FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=1 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=5']).count
    @reason_kyoto0_rate = (@reason_kyoto0.to_f / @manual_reject.to_f).round(3)
    @reason_sightseeing0_rate = (@reason_sightseeing0.to_f / @manual_reject.to_f).round(3)
    @reason_scenery0_rate = (@reason_scenery0.to_f / @manual_reject.to_f).round(3)
    @reason_old0_rate = (@reason_old0.to_f / @manual_reject.to_f).round(3)
    @reason_bot0_rate = (@reason_bot0.to_f / @manual_reject.to_f).round(3)
    @reason_other0_rate = (@reason_other0.to_f / @manual_reject.to_f).round(3)
    @reason_kyoto1_rate = (@reason_kyoto1.to_f / @auto_reject.to_f).round(3)
    @reason_sightseeing1_rate = (@reason_sightseeing1.to_f / @auto_reject.to_f).round(3)
    @reason_scenery1_rate = (@reason_scenery1.to_f / @auto_reject.to_f).round(3)
    @reason_old1_rate = (@reason_old1.to_f / @auto_reject.to_f).round(3)
    @reason_bot1_rate = (@reason_bot1.to_f / @auto_reject.to_f).round(3)
    @reason_other1_rate = (@reason_other1.to_f / @auto_reject.to_f).round(3)
  end

  def manual_tweet
    @tweets = Tweet.find_by_sql(['SELECT t.* FROM tweets t  WHERE t.auto_flag=0 ORDER BY t.created_at DESC'])
  end

  def manual_pending_tweet
    @tweets = Tweet.find_by_sql(['SELECT t.* FROM tweets t  WHERE t.auto_flag=0 AND t.pending=1 ORDER BY t.created_at DESC'])
  end

  def manual_accept_tweet
    @tweets = Tweet.find_by_sql(['SELECT t.* FROM tweets t  WHERE t.auto_flag=0 AND t.accept=1 ORDER BY t.updated_at DESC']).first(100)
  end

  def manual_reject_tweet
    @tweets = Tweet.find_by_sql(['SELECT t.* FROM tweets t  WHERE t.auto_flag=0 AND t.reject=1 ORDER BY t.updated_at DESC']).first(100)
  end

  def manual_weather_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=0 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=0']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def manual_crowd_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=0 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=1']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def manual_scenery_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=0 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=2']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def manual_trans_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=0 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=3']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def manual_ivent_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=0 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=4']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def manual_meal_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=0 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=5']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def manual_spot_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=0 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=6']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def manual_other_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=0 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=0']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def manual_kyoto_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=0 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=0']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def manual_sightseeing_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=0 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=1']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def manual_sceneryr_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=0 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=2']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def manual_old_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=0 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=3']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def manual_bot_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=0 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=4']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def manual_otherr_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=0 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=5']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def auto_tweet
    @tweets = Tweet.find_by_sql(['SELECT t.* FROM tweets t  WHERE t.auto_flag=1 ORDER BY t.created_at DESC'])
  end

  def auto_pending_tweet
    @tweets = Tweet.find_by_sql(['SELECT t.* FROM tweets t  WHERE t.auto_flag=1 AND t.pending=1 ORDER BY t.created_at DESC'])
  end

  def auto_accept_tweet
    @tweets = Tweet.find_by_sql(['SELECT t.* FROM tweets t  WHERE t.auto_flag=1 AND t.accept=1 ORDER BY t.updated_at DESC']).first(100)
  end

  def auto_reject_tweet
    @tweets = Tweet.find_by_sql(['SELECT t.* FROM tweets t  WHERE t.auto_flag=1 AND t.reject=1 ORDER BY t.updated_at DESC']).first(100)
  end

  def auto_weather_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=1 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=0']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def auto_crowd_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=1 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=1']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def auto_scenery_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=1 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=2']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def auto_trans_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=1 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=3']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def auto_ivent_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=1 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=4']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def auto_meal_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=1 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=5']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def auto_spot_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=1 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=6']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def auto_other_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_categories c ON v.id=c.vote_id WHERE t.accept=1 AND auto_flag=1 GROUP BY t.tweet_id, c.category_id HAVING count(*)>2 AND c.category_id=0']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def auto_kyoto_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=1 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=0']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def auto_sightseeing_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=1 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=1']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def auto_sceneryr_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=1 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=2']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def auto_old_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=1 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=3']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def auto_bot_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=1 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=4']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
  end

  def auto_otherr_tweet
    @tweets_id = Tweet.find_by_sql(['SELECT t.tweet_id FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id Inner Join vote_reasons c ON v.id=c.vote_id WHERE t.reject=1 AND auto_flag=1 GROUP BY t.tweet_id, c.reason_id HAVING count(*)>2 AND c.reason_id=5']).first(100).pluck(:tweet_id)
    @tweets = Tweet.where(tweet_id: @tweets_id)
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
