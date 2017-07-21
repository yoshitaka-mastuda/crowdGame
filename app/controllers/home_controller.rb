class HomeController < ApplicationController
  def index
    if user_signed_in?
      @can = Tweet.find_by_sql(['SELECT t.* FROM tweets t LEFT OUTER JOIN votes v ON t.tweet_id = v.tweet_id AND v.user_id = :user LEFT OUTER JOIN doing_lists d ON t.tweet_id = d.tweet_id WHERE t.user_id != :user AND t.votes_count < 5 AND v.user_id IS NULL AND d.user_id IS NULL AND t.delete_flag = 0 ORDER BY t.votes_count DESC', {user: current_user.id}]).length
    end
  end
end
