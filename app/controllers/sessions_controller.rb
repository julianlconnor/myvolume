class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    @user = User.new
    # OmniAuth Request
    if !request.env['omniauth.auth'].nil?
      auth = request.env['omniauth.auth']
      authorization = Authorization.find_by_provider_and_uid(auth["provider"], auth["uid"]) || Authorization.create_with_omniauth(auth)
      # Log the authorizing user in.
      #raise authorization.attributes['id'].to_yaml
      session[:uid] = authorization['id']
      flash.now.alert = "You have been logged in via Facebook."
      redirect_to root_url
    else
      user = User.authenticate(params[:email], params[:password])
      if user
        session[:user_id] = user.id
        flash.now.alert = "You are now Logged in!"
      else
        flash.now.alert = "Invalid email or password"
        # render "new"
      end
    end
    # respond_to do |format|
    #   format.js
    # end
  end
  
  def refresh
  end

  def destroy
    @user = User.new
    session[:user_id] = nil
    session[:uid] = nil
    flash.now.alert = "You have been Logged Out!"
    # respond_to do |format|
    #   format.js
    # end
  end

end