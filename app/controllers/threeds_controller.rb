class ThreedsController < ApplicationController
	require 'will_paginate/array'
  before_action :set_threed, only: [:show, :edit, :update, :destroy]

  # GET /threeds
  # GET /threeds.json
  def index
    @threeds = Threed.all.order('threed ASC').paginate(:page => params[:page], :per_page => 25)
  end

  # GET /threeds/1
  # GET /threeds/1.json
  def show
		@threed = Threed.find(params[:id])
		@movies= @threed.movies.order('name asc')
  end

  # GET /threeds/new
  def new
    @threed = Threed.new
  end

  # GET /threeds/1/edit
  def edit
  end

  # POST /threeds
  # POST /threeds.json
  def create
    @threed = Threed.new(threed_params)

    respond_to do |format|
      if @threed.save
        format.html { redirect_to @threed, notice: "3D created" }
        format.json { render :show, status: :created, location: @threed }
      else
        format.html { render :new, error: "Error when saving" }
        format.json { render json: @threed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /threeds/1
  # PATCH/PUT /threeds/1.json
  def update
    respond_to do |format|
      if @threed.update(threed_params)
        format.html { redirect_to @threed, notice: "3D saved" }
        format.json { render :show, status: :ok, location: @threed }
      else
        format.html { render :edit, error: "Error when saving" }
        format.json { render json: @threed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /threeds/1
  # DELETE /threeds/1.json
  def destroy
    @threed.destroy
    respond_to do |format|
      format.html { redirect_to threeds_url, notice: "3D deleted" }
      format.json { head :no_content }
    end
  end

  # Extra DEFs
  
  def import
		@file = params[:file]
		@fcsv = false
		if @file; @fcsv = File.extname(@file.path)=='.csv' ? true : false; end
		if @file && @fcsv
			Threed.import(params[:file])
			flash[:notice]="Import completed"
			else
			flash[:error]="Import failed"
			end
	redirect_to threeds_path
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_threed
      @threed = Threed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def threed_params
      params.require(:threed).permit(:threed, :notes)
    end
end
