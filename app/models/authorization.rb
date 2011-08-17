class Authorization < ActiveRecord::Base
  
  belongs_to :role
  
  has_many :authorization_favorites
  has_many :songs, :through => :authorization_favorites
  
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider
  
  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end

  def self.create_from_hash(hash, user = nil)
    user ||= User.create_from_hash!(hash)
    Authorization.create(:user => user, :uid => hash['uid'], :provider => hash['provider'])
  end
  
  def role?(role)
      return !!self.role.name.to_s
  end
  
  def self.create_with_omniauth(auth)
    create! do |authorization|
      authorization.provider = auth["provider"] if !auth["provider"].nil?
      authorization.uid = auth["uid"] if !auth["uid"].nil?
      authorization.alias = auth["user_info"]["nickname"] if !auth["user_info"]["nickname"].nil?
      authorization.name = auth["user_info"]["name"] if !auth["user_info"]["name"].nil?
      authorization.email = auth["user_info"]["email"] if !auth["user_info"]["email"].nil?
      authorization.avatar_url = auth["user_info"]["image"] if !auth["user_info"]["image"].nil?
    end
    # authorization = Authorization.new(  :provider   =>  auth["provider"],
    #                                     :uid        =>  auth["uid"],
    #                                     :alias      =>  auth["user_info"]["nickname"],
    #                                     :avatar_url =>  auth["user_info"]["image"])

  end
end
