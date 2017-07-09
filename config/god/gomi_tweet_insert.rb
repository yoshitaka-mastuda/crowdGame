require 'twitter'
require "rubygems"
require "active_record"
require 'yaml'

config = YAML.load_file('../database.yml')
ActiveRecord::Base.establish_connection(config["development"])

class Tweet < ActiveRecord::Base
end
class TwitterUser < ActiveRecord::Base
end


client = Twitter::REST::Client.new do |c|
  c.consumer_key = 'sH5GApBCzDxAwPUJpiVoZpBqg'
  c.consumer_secret = 'w3Inl2yoozmScILkWcwFUzRSB2FszbF9fVVbdgZQX8StdAoMhy'
  c.access_token = '260170495-3lf7SuJNNGcqz5dPspj11W1484i0cDGKKWLEs4GC'
  c.access_token_secret = 'HAR23aO4nDBpFbX3WW4EjCkLNokEivReUBNdvkEYIJqBB'
end


max_id = nil
loop do

  auto_count = Tweet.where(auto_flag: 1).count
  manual_count = Tweet.where(auto_flag: 0).count

  if auto_count < manual_count then
    result = client.search('京都+(天気 OR 観光 OR 交通 OR 電車 OR バス) -(東京都 OR RT)', count: 1, lang: 'ja', locale: 'ja', result_type: 'recent', since_id: max_id)
    max_id = result.attrs[:search_metadata][:max_id]
    result.take(1).reverse.each do |s|
      tweet = Tweet.new
      tweet.text = s.text
      tweet.tweet_id = s.id
      tweet.twitter_user_id = s.user.id
      tweet.user_id = 99999
      tweet.auto_flag = 1
      tweet.save if Tweet.find_by_tweet_id(tweet.tweet_id).nil?
      puts "insert"

      user = TwitterUser.new
      user.twitter_user_id = s.user.id
      user.screen_name = s.user.screen_name
      user.name = s.user.name
      user.save if TwitterUser.find_by_twitter_user_id(user.twitter_user_id).nil?
    end
  end

  sleep 10

end
