class UsersController < ApplicationController
  def new
    @user = User.new
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
