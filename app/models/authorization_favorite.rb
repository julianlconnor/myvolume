class AuthorizationFavorite < ActiveRecord::Base
  belongs_to :authorization
  belongs_to :song
end
