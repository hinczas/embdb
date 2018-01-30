class MformatsController < ApplicationController
	require 'will_paginate/array'
  before_action :set_mformat, only: [:show, :edit, :update, :destroy]

  # GET /mformats
  # GET /mformats.json
  def index
    @mformats = Mformat.all.order('mformat ASC').paginate(:page => params[:page], :per_page => 25)
  end

  # GET /mformats/1
  # GET /mformats/1.json
  def show
		@mformat = Mformat.find(params[:id])
		@movies= @mformat.movies.order('name asc')
  end

  # GET /mformats/new
  def new
    @mformat = Mformat.new
  end

  # GET /mformats/1/edit
  def edit
  end

  # POST /mformats
  # POST /mformats.json
  def create
    @mformat = Mformat.new(mformat_params)

    respond_to do |format|
      if @mformat.save
        format.html { 
			flash[:notice]="Format created"
			redirect_to @mformat }
        format.json { render :show, status: :created, location: @mformat }
      else
        format.html { 
			flash[:error]="Error when saving"
			render :new }
        format.json { render json: @mformat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mformats/1
  # PATCH/PUT /mformats/1.json
  def update
    respond_to do |format|
      if @mformat.update(mformat_params)
        format.html { redirect_to @mformat, notice: "Format saved" }
        format.json { render :show, status: :ok, location: @mformat }
      else
        format.html { render :edit, error: "Error when saving"  }
        format.json { render json: @mformat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mformats/1
  # DELETE /mformats/1.json
  def destroy
    @mformat.destroy
    respond_to do |format|
      format.html { redirect_to mformats_url, notice: "Format deleted"  }
      format.json { head :no_content }
    end
  end
  
  # Extra DEFs
  
  def import
		@file = params[:file]
		@fcsv = false
		if @file; @fcsv = File.extname(@file.path)=='.csv' ? true : false; end
		if @file && @fcsv
			Mformat.import(params[:file])
			flash[:notice]="Import completed"
			else
			flash[:error]="Import failed"
			end
		redirect_to mformats_path
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mformat
      @mformat = Mformat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mformat_params
      params.require(:mformat).permit(:mformat, :notes)
    end
end
