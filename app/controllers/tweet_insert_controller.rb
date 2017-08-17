require 'twitter'

class TweetInsertController < ApplicationController
  def index
  end

  def new
    flash.now[:alert] = '現在、収集作業は募集していません。'
    render "home/index"
    if current_user.tutorial == 0 or current_user.tutorial == 1 then
      flash.now[:alert] = '作業を開始するためにはチュートリアルが必要です。'
      render "home/index"
    else
      @tweet = Tweet.new
      current_user.accept_count = Tweet.where(:user_id => current_user.id, :accept => true).count
      current_user.pending_count = Tweet.where(:user_id => current_user.id, :pending => true).count
      current_user.total_count = current_user.accept_count + current_user.evaluation_count + current_user.evaluation_count2 + current_user.evaluation_count3 + current_user.evaluation_count4
      current_user.accept_point = current_user.accept_count * 5 + current_user.pending_count + current_user.reject_count
      current_user.total_point = current_user.accept_point + current_user.evaluation_point
      current_user.save

      a_count = Tweet.where(user_id: current_user.id, accept: 1, notice_flag: 0).count
      r_count = Tweet.where(user_id: current_user.id, reject: 1, notice_flag: 0).count
      Tweet.where(user_id: current_user.id, accept: 1, notice_flag: 0).each do |t|
        flash.now[:notice] = "あなたが収集したツイート「#{t.text}」など#{a_count}件が承認されました。"
        t.notice_flag=1
        t.save
      end
      Tweet.where(user_id: current_user.id, reject: 1, notice_flag: 0).each do |t|
        @reason = Vote.where(tweet_id: t.tweet_id).first
        flash.now[:alert] = "あなたが収集したツイート「#{t.text} 」など#{r_count}件が非承認となりました。収集ポイントをクリックすると非承認理由が確認できます。"
        t.notice_flag=1
        t.save
      end
    end
  end

  def show
  end

  def create

    id = params[:tweet][:tweet_id]
    if params[:tweet][:tweet_id].include?('twitter.com')
      ids = id.split('/')
      id = ids[ids.size - 1]
    end

    redirect_to new_tweet_insert_path, :alert => 'そのツイートは既に登録済みです。' if Tweet.where(tweet_id: id).count > 0

    client = Twitter::REST::Client.new do |c|
      c.consumer_key = 'sH5GApBCzDxAwPUJpiVoZpBqg'
      c.consumer_secret = 'w3Inl2yoozmScILkWcwFUzRSB2FszbF9fVVbdgZQX8StdAoMhy'
      c.access_token = '260170495-3lf7SuJNNGcqz5dPspj11W1484i0cDGKKWLEs4GC'
      c.access_token_secret = 'HAR23aO4nDBpFbX3WW4EjCkLNokEivReUBNdvkEYIJqBB'
    end

    begin
      @status = client.status(id)
      @url = "https://twitter.com/#{@status.user.screen_name}/status/#{id}"
    rescue Twitter::Error => e
      #render :error
      redirect_to new_tweet_insert_path, :alert => 'ツイートを見つけることができませんでした。他のツイートを探してください。'
    end

  end

  def store
    if params[:commit] == 'いいえ' then
      redirect_to new_tweet_insert_path
    else
      user = TwitterUser.new

      user.twitter_user_id = params[:user][:twitter_user_id]
      user.screen_name = params[:user][:screen_name]
      user.name = params[:user][:name]

      tweet = Tweet.new
      tweet.text = params[:tweet][:text]
      tweet.tweet_id = params[:tweet][:tweet_id]
      tweet.twitter_user_id = params[:user][:twitter_user_id]
      tweet.user_id = current_user.id
      tweet.created_at = params[:tweet][:created_at]
      tweet.auto_flag = 0
      tweet.version = 3

      user.save if TwitterUser.find_by_twitter_user_id(user.twitter_user_id).nil?
      tweet.save if Tweet.find_by_tweet_id(tweet.tweet_id).nil?

      current_user.tweet_count = Tweet.where(:user_id => current_user.id).count
      current_user.accept_count = Tweet.where(:user_id => current_user.id, :accept => true).count
      current_user.pending_count = Tweet.where(:user_id => current_user.id, :pending => true).count
      current_user.total_count = current_user.accept_count + current_user.evaluation_count + current_user.evaluation_count2  + current_user.evaluation_count3  + current_user.evaluation_count4
      current_user.accept_point = current_user.accept_count * 5 + current_user.pending_count + current_user.reject_count
      current_user.total_point = current_user.accept_point + current_user.evaluation_point
      current_user.save

      redirect_to new_tweet_insert_path, notice: 'ツイートを登録しました。'
    end
  end

  def confirm
    current_user.accept_count = Tweet.where(:user_id => current_user.id, :accept => true).count
    current_user.pending_count = Tweet.where(:user_id => current_user.id, :pending => true).count
    current_user.total_count = current_user.accept_count + current_user.evaluation_count + current_user.evaluation_count2  + current_user.evaluation_count3
    current_user.accept_point = current_user.accept_count * 5 + current_user.pending_count
    current_user.accept_point = current_user.accept_count * 5 + current_user.pending_count + current_user.reject_count
    current_user.save
    @accept_tweets = Tweet.where(:user_id => current_user.id, :accept => true).order('updated_at DESC').all
    @reject_tweets_kyoto = Tweet.find_by_sql(['SELECT * FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id INNER JOIN vote_reasons r ON v.id = r.vote_id WHERE t.user_id = :user AND t.reject=1 AND reason_id = 0',{user:current_user.id}]).uniq {|tweet| tweet.tweet_id}
    @reject_tweets_sightseeing = Tweet.find_by_sql(['SELECT * FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id INNER JOIN vote_reasons r ON v.id = r.vote_id WHERE t.user_id = :user AND t.reject=1 AND reason_id = 1',{user:current_user.id}]).uniq {|tweet| tweet.tweet_id}
    @reject_tweets_scene = Tweet.find_by_sql(['SELECT * FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id INNER JOIN vote_reasons r ON v.id = r.vote_id WHERE t.user_id = :user AND t.reject=1 AND reason_id = 2',{user:current_user.id}]).uniq {|tweet| tweet.tweet_id}
    @reject_tweets_old = Tweet.find_by_sql(['SELECT * FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id INNER JOIN vote_reasons r ON v.id = r.vote_id WHERE t.user_id = :user AND t.reject=1 AND reason_id = 3',{user:current_user.id}]).uniq {|tweet| tweet.tweet_id}
    @reject_tweets_bot = Tweet.find_by_sql(['SELECT * FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id INNER JOIN vote_reasons r ON v.id = r.vote_id WHERE t.user_id = :user AND t.reject=1 AND reason_id = 4',{user:current_user.id}]).uniq {|tweet| tweet.tweet_id}
    @reject_tweets_other = Tweet.find_by_sql(['SELECT * FROM tweets t INNER JOIN votes v ON t.tweet_id = v.tweet_id INNER JOIN vote_reasons r ON v.id = r.vote_id WHERE t.user_id = :user AND t.reject=1 AND reason_id = 5',{user:current_user.id}]).uniq {|tweet| tweet.tweet_id}
  end


  def pending
    current_user.accept_count = Tweet.where(:user_id => current_user.id, :accept => true).count
    current_user.pending_count = Tweet.where(:user_id => current_user.id, :pending => true).count
    current_user.total_count = current_user.accept_count + current_user.evaluation_count + current_user.evaluation_count2  + current_user.evaluation_count3  + current_user.evaluation_count4
    current_user.accept_point = current_user.accept_count * 5 + current_user.pending_count
    current_user.accept_point = current_user.accept_count * 5 + current_user.pending_count + current_user.reject_count
    current_user.save
    @pending_tweets = Tweet.where(:user_id => current_user.id, :pending => true).all
  end

  def reason
    @tweet = Tweet.where(:tweet_id => params[:t_id]).first
    @reason = Vote.where(:tweet_id => params[:t_id], :evaluation => 0)
  end

end
