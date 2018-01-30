class QualitiesController < ApplicationController
	require 'will_paginate/array'
  before_action :set_quality, only: [:show, :edit, :update, :destroy]

  # GET /qualities
  # GET /qualities.json
  def index
    @qualities = Quality.all.order('quality ASC').paginate(:page => params[:page], :per_page => 25)
  end

  # GET /qualities/1
  # GET /qualities/1.json
  def show
		@quality = Quality.find(params[:id])
		@movies= @quality.movies.order('name asc')
  end

  # GET /qualities/new
  def new
    @quality = Quality.new
  end

  # GET /qualities/1/edit
  def edit
  end

  # POST /qualities
  # POST /qualities.json
  def create
    @quality = Quality.new(quality_params)

    respond_to do |format|
      if @quality.save
        format.html { redirect_to @quality, notice: "Quality created" }
        format.json { render :show, status: :created, location: @quality }
      else
        format.html { render :new, error: "Error when saving" }
        format.json { render json: @quality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /qualities/1
  # PATCH/PUT /qualities/1.json
  def update
    respond_to do |format|
      if @quality.update(quality_params)
        format.html { redirect_to @quality, notice: "Quality saved" }
        format.json { render :show, status: :ok, location: @quality }
      else
        format.html { render :edit, error: "Error when saving" }
        format.json { render json: @quality.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /qualities/1
  # DELETE /qualities/1.json
  def destroy
    @quality.destroy
    respond_to do |format|
      format.html { redirect_to qualities_url, notice: "Quality deleted" }
      format.json { head :no_content }
    end
  end

  # Extra DEFs
  
  def import
		@file = params[:file]
		@fcsv = false
		if @file; @fcsv = File.extname(@file.path)=='.csv' ? true : false; end
		if @file && @fcsv
			Quality.import(params[:file])
			flash[:notice]="Import completed"
			else
			flash[:error]="Import failed"
			end
	redirect_to qualities_path
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quality
      @quality = Quality.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quality_params
      params.require(:quality).permit(:quality, :notes)
    end
end
