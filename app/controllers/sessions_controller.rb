class SessionsController < ApplicationController
	before_action :save_login_state, :only => [:login, :login_attempt]
	skip_before_action :authenticate_user, :only => [:login, :login_attempt]

  def login
  end
  
  def login_attempt
    authorized_user = User.authenticate(params[:username_or_email],params[:login_password])
    if authorized_user
      session[:user_id] = authorized_user.id
      flash[:notice] = "Wow Welcome again, you logged in as #{authorized_user.username}"
      redirect_to :home
    else
      flash[:error] = "Invalid Username or Password"
      redirect_to :login	
    end
  end
  
  def logout
	  reset_session
	  redirect_to :login
  end
  
  def home
  end

  def profile
  end

  def setting
  end
end
