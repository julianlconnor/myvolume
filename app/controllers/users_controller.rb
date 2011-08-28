class UsersController < ApplicationController
  #load_and_authorize_resource :only => [:edit, :create, :update, :destroy]
  def index
    redirect_to :root
  end
  def new
    @user = User.new
  end
  def favorite
    debugger
    @error = 0
    @user = User.new
    @song_id = params[:id]
    if current_user
      if session[:uid]
        # Handle an authorization favorite
        # Check to see if that record already exists
        favorite = AuthorizationFavorite.find_by_song_id_and_authorization_id(params[:id],current_user.id)
        if !favorite
          favorite = AuthorizationFavorite.new(:song_id => params[:id], :authorization_id => current_user.id)
          if favorite.save
            flash.now.alert = "Successfully added #{favorite.song.name} (#{favorite.song.mix_name}) to your favorites."
            favorite.song.favorite_count += 1
            current_user.favorite_count += 1
            favorite.song.save
          else
            @error = 1
            flash.now.alert = "Unable to add #{favorite.song.name} (#{favorite.song.mix_name}) to your favorites."
          end
        else
          @error = 1
          flash.now.alert = "Successfully removed #{favorite.song.name} (#{favorite.song.mix_name}) from your favorites."
          favorite.song.favorite_count -= 1
          current_user.favorite_count -= 1
          favorite.song.save
          favorite.destroy
        end
      elsif session[:user_id]
        # Handle a user favorite
        favorite = Favorite.find_by_song_id_and_user_id(params[:id],current_user.id)
        if !favorite
          favorite = Favorite.new(:song_id => params[:id], :user_id => current_user.id)
          if favorite.save
            flash.now.alert = "Successfully added #{favorite.song.name} (#{favorite.song.mix_name}) to your favorites."
            favorite.song.favorite_count += 1
            current_user.favorite_count += 1
            favorite.song.save
          else
            @error = 1
            flash.now.alert = "Unable to add #{favorite.song.name} (#{favorite.song.mix_name}) to your favorites."
          end
        else
          @error = 1
          flash.now.alert = "Successfully removed #{favorite.song.name} (#{favorite.song.mix_name}) from your favorites."
          favorite.song.favorite_count -= 1
          current_user.favorite_count -= 1
          favorite.song.save
          favorite.destroy
        end
      end
      current_user.save
    else
      flash.now.alert = "You must log in or register to favorite tracks. :)"
      @error = 1
    end
    @mostLoved = Song.find(:all, :limit => 10, :order => "favorite_count DESC, created_at DESC")
    @mostActive = mergeActiveAuthUsers()
  end
  
  def mergeActiveAuthUsers
    @u = User.find(:all, :limit=>5, :order => "favorite_count DESC")
    @a = Authorization.find(:all, :limit => 5, :order => "favorite_count DESC")
    @a = @a + @u
    @a = @a.sort {|x,y| x.favorite_count <=> y.favorite_count}.reverse
  end

  def show
    @user = User.find(params[:id])
  end
  
  def showAuth
    @auth = Authorization.find(params[:id])
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
