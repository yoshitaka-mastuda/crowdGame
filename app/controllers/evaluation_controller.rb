class EvaluationController < ApplicationController

  def index
  end

  def new
    if user_signed_in?
      if current_user.tutorial == 0 or current_user.tutorial == 2 then
        flash.now[:alert] = '作業を開始するためにはチュートリアルが必要です。'
        render "home/index"
      else
        current_user.accept_count = Tweet.where(:user_id => current_user.id, :accept => true).count
        current_user.pending_count = Tweet.where(:user_id => current_user.id, :pending => true).count
        current_user.total_count = current_user.accept_count + current_user.evaluation_count + current_user.evaluation_count2 + current_user.evaluation_count3
        current_user.accept_point = current_user.accept_count * 5 + current_user.pending_count + current_user.reject_count
        current_user.evaluation_point = current_user.evaluation_count*1 + current_user.evaluation_count2*1 + current_user.evaluation_count3*1
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
        session[:behavior] = []
        session[:behavior].push([0, Time.now])
        if DoingList.where(user_id: current_user.id).length > 0 then
          t_id = DoingList.where(user_id: current_user.id)[0].tweet_id
          @tweet = Tweet.where(tweet_id: t_id)[0]
        elsif Tweet.find_by_sql(['SELECT t.* FROM tweets t LEFT OUTER JOIN votes v ON t.tweet_id = v.tweet_id AND v.user_id = :user LEFT OUTER JOIN doing_lists d ON t.tweet_id = d.tweet_id WHERE t.user_id != :user AND t.votes_count < 5 AND v.user_id IS NULL AND d.user_id IS NULL AND t.delete_flag = 0 ORDER BY t.votes_count DESC', {user: current_user.id}]).length > 0 then
          @tweets = Tweet.find_by_sql(['SELECT t.* FROM tweets t LEFT OUTER JOIN votes v ON t.tweet_id = v.tweet_id AND v.user_id = :user LEFT OUTER JOIN doing_lists d ON t.tweet_id = d.tweet_id WHERE t.user_id != :user AND t.votes_count < 5 AND v.user_id IS NULL AND d.user_id IS NULL AND t.delete_flag = 0 ORDER BY t.votes_count DESC', {user: current_user.id}]).first(5)
          @tweet = @tweets[rand(@tweets.length)]
          DoingList.create(user_id: current_user.id, tweet_id: @tweet.tweet_id)
          DoingList.all.each do |c|
            time_spent = Time.now - c.created_at
            if time_spent > 3600 * 1
              c.destroy
            end
          end
        else
          flash.now[:alert] = '評価できるツイートがありません。収集作業を行なってください。'
          render "home/index"
        end
      end
    else
      render "home/index"
    end
  end

  def create
    tweet_id = params[:tweet][:tweet_id]
    if DoingList.where(user_id: current_user.id, tweet_id: tweet_id).count == 0 then
      redirect_to :action => 'new'
    else
      v = Vote.create(user_id: current_user.id, tweet_id: tweet_id, evaluation: params[:evaluation], version: 3, option: params[:option])
      session[:v_id] = v.id

      session[:behavior].each do |e|
        Behavior.create(user_id: current_user.id, tweet_id: tweet_id.to_i, state_id: e[0], created_at: e[1], vote_id: v.id)
      end
      Behavior.create(user_id: current_user.id, tweet_id: tweet_id.to_i, state_id: 3, vote_id: v.id)


      @done = DoingList.where(user_id: current_user.id, tweet_id: tweet_id)[0]
      @done.destroy

      i=0;
      Behavior.where(vote_id: v.id).order('created_at').each do |c|
        if i==0 then
          @old_state = c.state_id.to_s
          i = 1
        else
          @new_state = c.state_id.to_s
          if @old_state != "1" && @new_state == "2" then
            c.destroy
          end
          @old_state = @new_state
        end
      end

      if params[:evaluation] == "1" then
        params[:category].each do |e|
          VoteCategory.create(vote_id: v.id, category_id: e)
        end
      elsif params[:evaluation] == "0" then
        params[:reason].each do |e|
          VoteReason.create(vote_id: v.id, reason_id: e)
        end
      end

      vote_tweet = Tweet.where(tweet_id: tweet_id)
      vote_tweet[0].update_column(:votes_count, Vote.where(tweet_id: tweet_id).count)
      vote_tweet[0].save

      accept = Vote.where(tweet_id: tweet_id, evaluation: 1).count
      reject = Vote.where(tweet_id: tweet_id, evaluation: 0).count
      delete = Vote.where(tweet_id: tweet_id, evaluation: 2).count
      Tweet.where(:tweet_id => tweet_id)[0].update_column(:accept_count, accept)
      Tweet.where(:tweet_id => tweet_id)[0].update_column(:reject_count, reject)
      Tweet.where(:tweet_id => tweet_id)[0].update_column(:delete_count, delete)
      Tweet.where(:tweet_id => tweet_id)[0].save
      if Tweet.where(:tweet_id => tweet_id)[0].accept_count > 2 then
        Tweet.where(:tweet_id => tweet_id)[0].update_column(:accept, 1)
        Tweet.where(:tweet_id => tweet_id)[0].update_column(:pending, 0)
        Tweet.where(:tweet_id => tweet_id)[0].save
      elsif Tweet.where(:tweet_id => tweet_id)[0].reject_count > 2 then
        Tweet.where(:tweet_id => tweet_id)[0].update_column(:reject, 1)
        Tweet.where(:tweet_id => tweet_id)[0].update_column(:pending, 0)
        Tweet.where(:tweet_id => tweet_id)[0].save
      elsif Tweet.where(:tweet_id => tweet_id)[0].delete_count > 1 then
        Tweet.where(:tweet_id => tweet_id)[0].update_column(:delete_flag, 1)
        Tweet.where(:tweet_id => tweet_id)[0].update_column(:pending, 0)
        Tweet.where(:tweet_id => tweet_id)[0].save
      end

      current_user.accept_count = Tweet.where(:user_id => current_user.id, :accept => true).count
      current_user.pending_count = Tweet.where(:user_id => current_user.id, :pending => true).count

      current_user.evaluation_count = Vote.where(:user_id => current_user.id, :version => 1).count
      current_user.evaluation_count2 = Vote.where(:user_id => current_user.id, :version => 2).count
      current_user.evaluation_count3 = Vote.where(:user_id => current_user.id, :version => 3).count
      current_user.total_count = current_user.accept_count + current_user.evaluation_count + current_user.evaluation_count2 + current_user.evaluation_count3

      current_user.accept_point = current_user.accept_count * 5 + current_user.pending_count + current_user.reject_count
      current_user.evaluation_point = current_user.evaluation_count*1 + current_user.evaluation_count2*1 + current_user.evaluation_count3*1
      current_user.total_point = current_user.accept_point + current_user.evaluation_point

      current_user.save

      flash[:notice] = '作業結果を登録しました。次のツイートを評価してください。'
      redirect_to :action => 'new'
    end
  end

end

