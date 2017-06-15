class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :twitter_user, class_name: 'TwitterUser',
             foreign_key: 'twitter_user_id', primary_key: 'twitter_user_id'

  def url
    "https://twitter.com/#{self.twitter_user.screen_name}/status/#{self.tweet_id}"
  end
end
