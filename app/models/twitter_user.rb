class TwitterUser < ApplicationRecord
  has_many :tweets

  def tweet_count
    tweets.count
  end
end
