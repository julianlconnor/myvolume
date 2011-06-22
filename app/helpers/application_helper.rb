module ApplicationHelper
  def is_favorite(s_id)
    flag = false
    if current_user
      if session[:user_id]
        favorite = Favorite.find_by_user_id_and_song_id(session[:user_id],s_id)
        if favorite
          flag = true
        end
      elsif session[:uid]
        favorite = AuthorizationFavorite.find_by_authorization_id_and_song_id(session[:uid],s_id)
        if favorite
          flag = true
        end
      end
    end
  end
end
