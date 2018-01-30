class MtypesController < ApplicationController
	require 'will_paginate/array'
  before_action :set_mtype, only: [:show, :edit, :update, :destroy]

  # GET /mtypes
  # GET /mtypes.json
  def index
    @mtypes = Mtype.all.order('mtype ASC').paginate(:page => params[:page], :per_page => 25)
  end

  # GET /mtypes/1
  # GET /mtypes/1.json
  def show
		@mtype = Mtype.find(params[:id])
		@movies= @mtype.movies.order('name asc')
  end

  # GET /mtypes/new
  def new
    @mtype = Mtype.new
  end

  # GET /mtypes/1/edit
  def edit
  end

  # POST /mtypes
  # POST /mtypes.json
  def create
    @mtype = Mtype.new(mtype_params)

    respond_to do |format|
      if @mtype.save
        format.html { redirect_to @mtype, notice: "Type created" }
        format.json { render :show, status: :created, location: @mtype }
      else
        format.html { render :new, error: "Error when saving" }
        format.json { render json: @mtype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mtypes/1
  # PATCH/PUT /mtypes/1.json
  def update
    respond_to do |format|
      if @mtype.update(mtype_params)
        format.html { redirect_to @mtype, notice: "Type saved" }
        format.json { render :show, status: :ok, location: @mtype }
      else
        format.html { render :edit, error: "Error when saving" }
        format.json { render json: @mtype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mtypes/1
  # DELETE /mtypes/1.json
  def destroy
    @mtype.destroy
    respond_to do |format|
      format.html { redirect_to mtypes_url, notice: "Type deleted" }
      format.json { head :no_content }
    end
  end

  # Extra DEFs
  
  def import
		@file = params[:file]
		@fcsv = false
		if @file; @fcsv = File.extname(@file.path)=='.csv' ? true : false; end
		if @file && @fcsv
			Mtype.import(params[:file])
			flash[:notice]="Import completed"
			else
			flash[:error]="Import failed"
			end
	redirect_to mtypes_path
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mtype
      @mtype = Mtype.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mtype_params
      params.require(:mtype).permit(:mtype, :notes)
    end
end
