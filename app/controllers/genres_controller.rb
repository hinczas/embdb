class GenresController < ApplicationController
	require 'will_paginate/array'
  before_action :set_genre, only: [:show, :edit, :update, :destroy]

  # GET /genres
  # GET /genres.json
  def index
    @genres = Genre.all.order('name ASC').paginate(:page => params[:page], :per_page => 25)
  end

  # GET /genres/1
  # GET /genres/1.json
  def show
		@genre = Genre.find(params[:id])
		@movies= @genre.movies.order('name asc')
  end

  # GET /genres/new
  def new
    @genre = Genre.new
  end

  # GET /genres/1/edit
  def edit
  end

  # POST /genres
  # POST /genres.json
  def create
    @genre = Genre.new(genre_params)

    respond_to do |format|
      if @genre.save
        format.html { redirect_to @genre, notice: "Genre created" }
        format.json { render :show, status: :created, location: @genre }
      else
        format.html { render :new, error: "Error when saving" }
        format.json { render json: @genre.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /genres/1
  # PATCH/PUT /genres/1.json
  def update
    respond_to do |format|
      if @genre.update(genre_params)
        format.html { redirect_to @genre,  notice: "Genre saved" }
        format.json { render :show, status: :ok, location: @genre }
      else
        format.html { render :edit,  error: "Error when saving" }
        format.json { render json: @genre.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /genres/1
  # DELETE /genres/1.json
  def destroy
    @genre.destroy
    respond_to do |format|
      format.html { redirect_to genres_url,  notice: "Genre deleted" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_genre
      @genre = Genre.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def genre_params
      params.require(:genre).permit(:name, :notes)
    end
end
