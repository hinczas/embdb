class PublishersController < ApplicationController
	require 'will_paginate/array'
  before_action :set_publisher, only: [:show, :edit, :update, :destroy]
	def index
		@publishers = Publisher.all.order('name asc').paginate(:page => params[:page], :per_page => 25)
	end
	def show
		@publisher = Publisher.find(params[:id])
		@books= @publisher.books.order('name asc')
	end
	def edit
		@publisher = Publisher.find(params[:id])
	end
	def new
		@publisher = Publisher.new
	end

  # POST /publishers
  # POST /publishers.json
  def create
    @publisher = Publisher.new(publisher_params)

    respond_to do |format|
      if @publisher.save
        format.html { redirect_to @publisher, notice: "Publisher created" }
        format.json { render :show, status: :created, location: @publisher }
      else
        format.html { render :new, error: "Create failed" }
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /publishers/1
  # PATCH/PUT /publishers/1.json
  def update
    respond_to do |format|
      if @publisher.update(publisher_params)
        format.html { redirect_to @publisher, notice: "Publisher saved" }
        format.json { render :show, status: :ok, location: @publisher }
      else
        format.html { render :edit, error: "Save failed" }
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /publishers/1
  # DELETE /publishers/1.json
  def destroy
    @publisher.destroy
    respond_to do |format|
      format.html { redirect_to publishers_url, notice: "Publisher deleteed" }
      format.json { head :no_content }
    end
  end
	def import
		@file = params[:file]
		@fcsv = false
		if @file; @fcsv = File.extname(@file.path)=='.csv' ? true : false; end
		if @file && @fcsv
			Publisher.import(params[:file])
			flash[:notice]="Import completed"
			else
			flash[:error]="Import failed"
			end
		redirect_to publishers_path
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_publisher
      @publisher = Publisher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def publisher_params
      params.require(:publisher).permit(:name, :full_name, :address, :website, :contact, :notes)
    end
end
