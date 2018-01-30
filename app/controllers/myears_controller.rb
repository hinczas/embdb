class MyearsController < ApplicationController
	require 'will_paginate/array'
  before_action :set_myear, only: [:show, :edit, :update, :destroy]

  # GET /myears
  # GET /myears.json
  def index
    @myears = Myear.all.order('myear ASC').paginate(:page => params[:page], :per_page => 25)
  end

  # GET /myears/1
  # GET /myears/1.json
  def show
		@myear = Myear.find(params[:id])
		@movies= @myear.movies.order('name asc')
  end

  # GET /myears/new
  def new
    @myear = Myear.new
  end

  # GET /myears/1/edit
  def edit
  end

  # POST /myears
  # POST /myears.json
  def create
    @myear = Myear.new(myear_params)

    respond_to do |format|
      if @myear.save
        format.html { redirect_to @myear, notice: "Year created" }
        format.json { render :show, status: :created, location: @myear }
      else
        format.html { render :new, error: "Error when saving" }
        format.json { render json: @myear.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /myears/1
  # PATCH/PUT /myears/1.json
  def update
    respond_to do |format|
      if @myear.update(myear_params)
        format.html { redirect_to @myear, notice: "Year saved" }
        format.json { render :show, status: :ok, location: @myear }
      else
        format.html { render :edit, error: "Error when saving" }
        format.json { render json: @myear.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /myears/1
  # DELETE /myears/1.json
  def destroy
    @myear.destroy
    respond_to do |format|
      format.html { redirect_to myears_url, notice: "Year deleted" }
      format.json { head :no_content }
    end
  end

  # Extra DEFs
  
  def import
		@file = params[:file]
		@fcsv = false
		if @file; @fcsv = File.extname(@file.path)=='.csv' ? true : false; end
		if @file && @fcsv
			Myear.import(params[:file])
			flash[:notice]="Import completed"
			else
			flash[:error]="Import failed"
			end
	redirect_to myears_path
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_myear
      @myear = Myear.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def myear_params
      params.require(:myear).permit(:myear, :notes)
    end
end
