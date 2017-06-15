class AdminController < ApplicationController
  before_action :confirm_admin_user!
  def index

  end

  def user_list
    @users = User.all.includes(:tweets).order(:username)
  end

  def user_show
    @user = User.find(params[:user_id])
  end

  private
    def confirm_admin_user!
      redirect_to root_path unless current_user.admin?
    end
end
