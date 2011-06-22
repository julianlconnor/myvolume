class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def favorite
    @error = 0
    @song_id = params[:id]
    if current_user
      if session[:uid]
        # Handle an authorization favorite
        # Check to see if that record already exists
        favorite = AuthorizationFavorite.find_by_song_id_and_authorization_id(params[:id],current_user.id)
        if !favorite
          favorite = AuthorizationFavorite.new(:song_id => params[:id], :authorization_id => current_user.id)
          if favorite.save
            flash.now.alert = "Successfully added to your favorites."
          else
            @error = 1
            flash.now.alert = "Unable to add that track to your favorites."
          end
        else
          @error = 1
          flash.now.alert = "That track is already one of your favorites."
        end
      elsif session[:user_id]
        # Handle a user favorite
        favorite = Favorite.find_by_song_id_and_user_id(params[:id],current_user.id)
        if !favorite
          favorite = Favorite.new(:song_id => params[:id], :user_id => current_user.id)
          if favorite.save
            flash.now.alert = "Successfully added to your favorites."
          else
            @error = 1
            flash.now.alert = "Unable to add that track to your favorites."
          end
        else
          @error = 1
          flash.now.alert = "That track is already one of your favorites."
        end
      end
    else
      flash.now.alert = "You must log in or register to favorite tracks. :)"
      @error = 1
    end
  end
  def create
    @user = User.new(params[:user])
    if @user.save
      flash.now.alert = "You have successfully registered. Please log-in."
    else
      render "errors.js.erb"
    end
  end

end
