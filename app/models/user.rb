class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,  :authentication_keys => [:login]

  has_many :tweets

  attr_accessor :login
  validate :validate_username
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  def point
    self.tweets.count
  end

  def reject_count
    self.tweet_count - self.accept_count - self.pending_count
  end

  def rest_point
    self.total_point - self.payment
  end

  def insert_rate
    if (self.accept_count + self.reject_count) != 0 then
      self.accept_count.to_f/(self.accept_count.to_f + self.reject_count.to_f)*100.0
    else
      0.0
    end
  end

  def ranking
    User.all.order('total_point DESC').select("id").pluck(:id).find_index(self.id.to_i) + 1
  end

  def higher_point
    User.all.order('total_point DESC').limit(1).offset(self.ranking-2).select('total_point').pluck('total_point')[0]
  end

  def rank_up_point
    if self.ranking == 1 then
      0
    else
      self.higher_point - self.total_point
    end
  end

  def doing_worker
    DoingList.count
  end

  def worker
    User.count
  end


  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end
end
