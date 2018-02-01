class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery prepend: true
  before_action :create_admin
  before_action :authenticate_user
  before_action :check_permissions, only: [:new, :create, :edit, :update, :destroy]
  
  protected 
	def authenticate_user
	  if session[:user_id]
		 # set current user object to @current_user object variable
		@current_user = User.find session[:user_id] 
		return true	
	  else
		redirect_to :login
		return false
	  end
	end
	
	def save_login_state	
	  if session[:user_id]
		redirect_to :home
		return false
	  else
		return true
	  end
	end
  
    def check_admin(id="")
		if session[:user_id]
			id = session[:user_id]
			level = User.find(id).level
			if level==0 or level==1
				return true
			else 
				redirect_to :denied
				return false
			end
		else 
			return true
		end
	end
	
	def check_permissions(id="")
		id = params[:id].to_f
		level = User.find(session[:user_id]).level
		if session[:user_id]==id or level < 2
			return true
		else 
			redirect_to :back
			flash[:error]="You do not have the permissions"
			return false 
		end
	end
	
	private 
	def create_admin
	usr_pass=SecureRandom.hex
		if User.all.any?
		else 		 
		 @admin = User.new(username: "admin", password: usr_pass, password_confirmation: usr_pass, level: 0)
		 @admin.save
		 File.open(Rails.root.join('public', "new_pass.tmp"), 'wb') do |file|
			file.write(usr_pass)
		end
		 flash[:notice]="Admin account set up"
		end
	end
end
