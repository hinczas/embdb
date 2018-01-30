class MlanguagesController < ApplicationController
	require 'will_paginate/array'
  before_action :set_mlanguage, only: [:show, :edit, :update, :destroy]

  # GET /mlanguages
  # GET /mlanguages.json
  def index
    @mlanguages = Mlanguage.all.order('mlanguage ASC').paginate(:page => params[:page], :per_page => 25)
  end

  # GET /mlanguages/1
  # GET /mlanguages/1.json
  def show
		@mlanguage = Mlanguage.find(params[:id])
		@movies= @mlanguage.movies.order('name asc')
  end

  # GET /mlanguages/new
  def new
    @mlanguage = Mlanguage.new
  end

  # GET /mlanguages/1/edit
  def edit
  end

  # POST /mlanguages
  # POST /mlanguages.json
  def create
    @mlanguage = Mlanguage.new(mlanguage_params)

    respond_to do |format|
      if @mlanguage.save
        format.html { redirect_to @mlanguage, notice: "Language created"  }
        format.json { render :show, status: :created, location: @mlanguage }
      else
        format.html { render :new, error: "Error when saving"  }
        format.json { render json: @mlanguage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mlanguages/1
  # PATCH/PUT /mlanguages/1.json
  def update
    respond_to do |format|
      if @mlanguage.update(mlanguage_params)
        format.html { redirect_to @mlanguage, notice: "Language saved"  }
        format.json { render :show, status: :ok, location: @mlanguage }
      else
        format.html { render :edit, error: "Error when saving"  }
        format.json { render json: @mlanguage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mlanguages/1
  # DELETE /mlanguages/1.json
  def destroy
    @mlanguage.destroy
    respond_to do |format|
      format.html { redirect_to mlanguages_url, notice: "Language deleted"  }
      format.json { head :no_content }
    end
  end

  # Extra DEFs
  
  def import
		@file = params[:file]
		@fcsv = false
		if @file; @fcsv = File.extname(@file.path)=='.csv' ? true : false; end
		if @file && @fcsv
			Mlanguage.import(params[:file])
			flash[:notice]="Import completed" 
			else
			flash[:error]="Import failed" 
			end
		redirect_to mlanguages_path
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mlanguage
      @mlanguage = Mlanguage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mlanguage_params
      params.require(:mlanguage).permit(:mlanguage, :notes)
    end
end
