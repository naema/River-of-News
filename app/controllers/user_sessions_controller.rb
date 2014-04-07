class UserSessionsController < ApplicationController
  def new
    if current_user
      redirect_to root_url
    else
      @user = User.new
    end
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_back_or_to root_url
    else
      flash.now[:alert] = "Incorrect email or password."
      render action: "new"
    end
  end

  def destroy
    logout
    redirect_to root_url
  end
end
