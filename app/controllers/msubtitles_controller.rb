class MsubtitlesController < ApplicationController
	require 'will_paginate/array'
  before_action :set_msubtitle, only: [:show, :edit, :update, :destroy]

  # GET /msubtitles
  # GET /msubtitles.json
  def index
    @msubtitles = Msubtitle.all.order('msubtitle ASC').paginate(:page => params[:page], :per_page => 25)
  end

  # GET /msubtitles/1
  # GET /msubtitles/1.json
  def show
		@msubtitle = Msubtitle.find(params[:id])
		@movies= @msubtitle.movies.order('name asc')
  end

  # GET /msubtitles/new
  def new
    @msubtitle = Msubtitle.new
  end

  # GET /msubtitles/1/edit
  def edit
  end

  # POST /msubtitles
  # POST /msubtitles.json
  def create
    @msubtitle = Msubtitle.new(msubtitle_params)

    respond_to do |format|
      if @msubtitle.save
        format.html { redirect_to @msubtitle, notice: "Subtitles saved" }
        format.json { render :show, status: :created, location: @msubtitle }
      else
        format.html { render :new, error: "Error when saving" }
        format.json { render json: @msubtitle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /msubtitles/1
  # PATCH/PUT /msubtitles/1.json
  def update
    respond_to do |format|
      if @msubtitle.update(msubtitle_params)
        format.html { redirect_to @msubtitle, notice: "Subtitles saved" }
        format.json { render :show, status: :ok, location: @msubtitle }
      else
        format.html { render :edit, error: "Error when saving" }
        format.json { render json: @msubtitle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /msubtitles/1
  # DELETE /msubtitles/1.json
  def destroy
    @msubtitle.destroy
    respond_to do |format|
      format.html { redirect_to msubtitles_url, notice: "Subtitles deleted" }
      format.json { head :no_content }
    end
  end

  # Extra DEFs
  
  def import
		@file = params[:file]
		@fcsv = false
		if @file; @fcsv = File.extname(@file.path)=='.csv' ? true : false; end
		if @file && @fcsv
			Msubtitle.import(params[:file])
			flash[:notice]="Import completed"
			else
			flash[:error]="Import failed"
			end
	redirect_to msubtitles_path
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_msubtitle
      @msubtitle = Msubtitle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def msubtitle_params
      params.require(:msubtitle).permit(:msubtitle, :notes)
    end
end
