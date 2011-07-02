class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    @user = User.new
    # OmniAuth Request
    if !request.env['omniauth.auth'].nil?
      auth = request.env['omniauth.auth']
      authorization = Authorization.find_by_provider_and_uid(auth["provider"], auth["uid"]) || Authorization.create_with_omniauth(auth)
      session[:uid] = authorization['id']
      flash.now.alert = "You have been logged in via Facebook."
      redirect_to root_url
    else
      # Regular authentication request
      user = User.authenticate(params[:email], params[:password])
      if user
        session[:user_id] = user.id
        flash.now.alert = "You are now Logged in!"
      else
        flash.now.alert = "Invalid email or password"
      end
    end
    @charts = Chart.paginate :page => params[:page], :order => "publish_date desc"
    @topdownloads = TopDownload.paginate :page => params[:page], :order => "rank asc"
    @mostLoved = Song.find(:all, :limit => 10, :order => "favorite_count DESC, created_at DESC")
  end
  
  def refresh
  end

  def destroy
    @user = User.new
    session[:user_id] = nil
    session[:uid] = nil
    flash.now.alert = "You have been Logged Out!"
    @charts = Chart.paginate :page => params[:page], :order => "publish_date desc"
    @topdownloads = TopDownload.paginate :page => params[:page], :order => "rank asc"
  end

end