require 'twitter'

class TweetInsertController < ApplicationController
  def index
  end

  def new
    @tweet = Tweet.new
    current_user.accept_count = Tweet.where(:user_id => current_user.id, :accept => true).count
    current_user.pending_count = Tweet.where(:user_id => current_user.id, :pending => true).count
    current_user.total_count = current_user.accept_count + current_user.evaluation_count
    current_user.save

    a_count = Tweet.where(user_id: current_user.id, accept: 1, notice_flag: 0).count
    r_count = Tweet.where(user_id: current_user.id, reject: 1, notice_flag: 0).count
    Tweet.where(user_id: current_user.id, accept: 1, notice_flag: 0).each do |t|
      flash.now[:notice] = "あなたが収集したツイート「#{t.text}」など#{a_count}件が承認されました。"
      t.notice_flag=1
      t.save
    end
    Tweet.where(user_id: current_user.id, reject: 1, notice_flag: 0).each do |t|
      flash.now[:alert] = "あなたが収集したツイート「#{t.text} 」など#{r_count}件が拒否されました。"
      t.notice_flag=1
      t.save
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

    redirect_to new_tweet_insert_path, :alert => 'そのツイートは既に登録済みです。'  if Tweet.where(tweet_id: id).count > 0

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

      user.save if TwitterUser.find_by_twitter_user_id(user.twitter_user_id).nil?
      tweet.save if Tweet.find_by_tweet_id(tweet.tweet_id).nil?

      current_user.tweet_count = Tweet.where(:user_id => current_user.id).count
      current_user.accept_count = Tweet.where(:user_id => current_user.id, :accept => true).count
      current_user.pending_count = Tweet.where(:user_id => current_user.id, :pending => true).count
      current_user.total_count = current_user.accept_count + current_user.evaluation_count
      current_user.save

      redirect_to new_tweet_insert_path, notice: 'ツイートを登録しました。'
    end
  end

  def confirm
    current_user.accept_count = Tweet.where(:user_id => current_user.id, :accept => true).count
    current_user.pending_count = Tweet.where(:user_id => current_user.id, :pending => true).count
    current_user.total_count = current_user.accept_count + current_user.evaluation_count
    current_user.save
    @accept_tweets = Tweet.where(:user_id => current_user.id, :accept => true).order('updated_at DESC').all
    @reject_tweets = Tweet.where(:user_id => current_user.id, :reject => true).order('updated_at DESC').all
  end

  def pending
    current_user.accept_count = Tweet.where(:user_id => current_user.id, :accept => true).count
    current_user.pending_count = Tweet.where(:user_id => current_user.id, :pending => true).count
    current_user.total_count = current_user.accept_count + current_user.evaluation_count
    current_user.save
    @pending_tweets = Tweet.where(:user_id => current_user.id, :pending => true).order('updated_at DESC').all
  end

  def reason
    @tweet = Tweet.where(:tweet_id => params[:t_id]).first
    @reason = Vote.where(:tweet_id => params[:t_id], :evaluation => 0)
  end

end
