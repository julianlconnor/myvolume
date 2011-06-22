class Authorization < ActiveRecord::Base
  
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
  
  def self.create_with_omniauth(auth)
    create! do |authorization|
      authorization.provider = auth["provider"]
      authorization.uid = auth["uid"]
      authorization.alias = auth["user_info"]["nickname"]
      authorization.avatar_url = auth["user_info"]["image"]
    end
    # authorization = Authorization.new(  :provider   =>  auth["provider"],
    #                                     :uid        =>  auth["uid"],
    #                                     :alias      =>  auth["user_info"]["nickname"],
    #                                     :avatar_url =>  auth["user_info"]["image"])

  end
end
