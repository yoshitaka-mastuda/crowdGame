require 'twitter'

class TweetInsertController < ApplicationController
  def index
    @tweets = Tweet.all
  end

  def new
    @tweet = Tweet.new
  end

  def show
  end

  def create

    id = params[:tweet][:tweet_id]
    if params[:tweet][:tweet_id].include?('twitter.com')
      ids = id.split('/')
      id = ids[ids.size - 1]
    end

    redirect_to new_tweet_insert_path, :alert => 'そのツイートは既に登録済みです'  if Tweet.where(tweet_id: id).count > 0

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
      render :error
    end



  end

  def store
    redirect_to new_tweet_insert_path if params[:commit] == 'いいえ'
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

    user.save if TwitterUser.find_by_twitter_user_id(user.twitter_user_id).nil?
    tweet.save if Tweet.find_by_tweet_id(tweet.tweet_id).nil?

    current_user.tweet_count = Tweet.where(:user_id => current_user.id).count
    current_user.confirm_count = Tweet.where(:user_id => current_user.id, :confirm => true).count
    current_user.pending_count = Tweet.where(:user_id => current_user.id, :pending => true).count
    current_user.save

    redirect_to new_tweet_insert_path, notice: 'ツイートを投稿しました'

  end

end
