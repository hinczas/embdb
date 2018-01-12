class AuthorsController < ApplicationController
	require 'will_paginate/array'
  before_action :set_author, only: [:show, :edit, :update, :destroy]
  
  def index
    @authors = Author.all.order('last_name asc').paginate(:page => params[:page], :per_page => 25)
  end
  def show
		@author = Author.find(params[:id])
		@books= @author.books.order('last_name asc')
  end
  def new
    @author = Author.new
  end
  def edit
		@author = Author.find(params[:id])
  end

  # POST /authors
  # POST /authors.json
  def create
		
    @author = Author.new(author_params)

    respond_to do |format|
      if @author.save
        format.html { redirect_to @author, notice: "Author created" }
        format.json { render :show, status: :created, location: @author }
      else
        format.html { render :new, error: "Error when saving"  }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authors/1
  # PATCH/PUT /authors/1.json
  def update
    respond_to do |format|
      if @author.update(author_params)
        format.html { redirect_to @author, notice: "Author saved"  }
        format.json { render :show, status: :ok, location: @author }
      else
        format.html { render :edit }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authors/1
  # DELETE /authors/1.json
  def destroy
    @author.destroy
    respond_to do |format|
      format.html { redirect_to authors_url, notice: "Author deleted"  }
      format.json { head :no_content }
    end
  end
	def import
		@file = params[:file]
		@fcsv = false
		if @file; @fcsv = File.extname(@file.path)=='.csv' ? true : false; end
		if @file && @fcsv
			Author.import(params[:file])
			flash[:notice]="Import completed"
			else 
			flash[:error]="Import failed"
		end
		redirect_to authors_path
	end
	
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = Author.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def author_params
      params.require(:author).permit(:name, :last_name, :notes)
    end
end
