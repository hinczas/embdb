class UsersController < ApplicationController
	require 'will_paginate/array'
	skip_before_action :authenticate_user, :only => [:new, :create]
	before_action :check_admin, :only => [:new, :create]
	before_action :set_user, only: [:show, :edit, :update, :destroy]
	before_action :check_permissions, only: [:show, :edit, :update, :destroy]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    lev = 2
    if params[:user_level]
		lev = params[:user_level]
	end
	@user.level=lev	
    if @user.save
      flash[:notice] = "You signed up successfully"
      redirect_to :login
    else
      flash[:error] = "Form is invalid"
	  render :new
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    lev = 2
    if params[:user_level]
		lev = params[:user_level]
		@user.level=lev	
		@user.save
	end
	  if @user.update(user_params)
		flash[:notice]= 'User was successfully updated.' 
		@user.save
		redirect_to @user 
	  else
		 render 'edit'
	  end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
	usr_id = @user.id	
    @user.destroy
    if session[:user_id] == usr_id
		reset_session
		redirect_to :login 
	else 
		redirect_to users_url 
	end
    flash[:notice]='User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
		if params[:id] 
			@user = User.find(params[:id])
		else
			@user = User.find(session[:user_id])
		end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :middle_name, :surname, :birth_date, :address, :mobile, :level, :email, :photo, :notes, :username, :password, :password_confirmation)
    end
end
