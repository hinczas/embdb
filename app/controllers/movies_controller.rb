class MoviesController < ApplicationController
	require 'will_paginate/array'
	require 'rest_client'
	require 'json'
	require 'open-uri'
	
	helper_method :sort_column, :sort_direction
  # INDEX
  def index
    @movies = Movie.all.order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page => 27)
    
    if params[:layout]
			Rails.configuration.movies_layout=params[:layout]
	end
	
	if params[:search]
		@movies = Movie.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page => 27)
	else
		@movies = Movie.order(sort_column + ' ' + sort_direction).all.paginate(:page => params[:page], :per_page => 27)
	end
		Rails.configuration.m_sort = sort_column 
		Rails.configuration.m_dir = sort_direction 
	respond_to do |format|
	  format.html
	  format.tsv { send_data Movie.all.all_csv, filename: "all-movies-#{Date.today}.csv" }
	end  
  end

  # SHOW
  def show
		@movie = Movie.find(params[:id])
  end
  
  # NEW
  def new
    @movie = Movie.new
    @genre = Genre.all
  end

  # EDIT
  def edit
	@movie = Movie.find(params[:id])
  end
  
  # IMPORT
  def import
		@file = params[:file]
		@fcsv = false
		if @file; @fcsv = File.extname(@file.path)=='.csv' ? true : false; end
		if @file && @fcsv
			Movie.import(params[:file])
				flash[:notice] = "Import completed"
				else
				flash[:error] = "Import failed"
			end
	redirect_to movies_path
  end
  
  # CREATE
  def create
	if params[:'lookup_api_new.x']
		call_api
	else 
  		uploaded_io = params[:movie][:poster]
  		web_url = params[:web_photo]
		if web_url!=''
			file_name=SecureRandom.hex
			begin
				download = open(web_url)
				IO.copy_stream(download, 'public/images/'+file_name)
			rescue => ex
				flash[:notice] = "Invalid image url. Image not found"
			end
		else 
			if uploaded_io
				file_name=SecureRandom.hex
				File.open(Rails.root.join('public', 'images', file_name), 'wb') do |file|
				file.write(uploaded_io.read)
			 end
			end		
		end
		@movie = Movie.new(movie_params)		
		own=params[:m_own]
		if own
		@movie.own='1'
		end
		title=params[:title]
		synopsis=params[:sunopsis]
		if uploaded_io or web_url; @movie.poster = file_name; end		
		@movie.imdb=params[:imdb]
		@movie.actor=params[:actor]
		@movie.director=params[:director]
		@movie.writer=params[:writer]
		@movie.title=title
		@movie.sunopsis=synopsis
		@genres=params[:genre_ids]
		if @movie.save 
		 if @genres
		  @genres.each do |g|
		   if g!=''
			@genre = Genre.find(g)
			@genre.movies << @movie
		   end
		  end
		 end
				flash[:notice] = "Movie saved"
		else 
				flash[:error] = "Error when saving"
			render :new
		end
		redirect_to @movie
	end
  end
  
  # UPDATE
  def update 
	if params[:'lookup_api_edit.x']
		call_api
	else 
		@movie = Movie.find(params[:id])
  		file_name = @movie.poster
  		org_name = @movie.poster
		del = params[:del_photo]
  		uploaded_io = params[:movie][:poster]
  		web_url = params[:web_photo]
		if web_url!=''
			file_name=SecureRandom.hex
			puts file_name
			begin
				puts web_url
				download = open(web_url)
				puts download
				IO.copy_stream(download, 'public/images/'+file_name)
			rescue => ex
				flash[:error] = "Invalid image url. Image not found"
				puts "Invalid url. Image not found"
				file_name=org_name
			end
		else 
			if uploaded_io
				file_name=SecureRandom.hex
				File.open(Rails.root.join('public', 'images', file_name), 'wb') do |file|
				file.write(uploaded_io.read)
			 end
			end		
		end
		cown=params[:m_own]
		title=params[:title]
		synopsis=params[:sunopsis]
	  if @movie.update(movie_params)
		if cown
		 @movie.own='1'
		 else 
		 @movie.own= nil
		end
		 if del 
			file_name=nil
			File.delete(Rails.root.join('public', 'images', org_name))
			end
		 if del or uploaded_io or web_url
			@movie.poster = file_name
		 end
		@movie.imdb=params[:imdb]
		@movie.actor=params[:actor]
		@movie.director=params[:director]
		@movie.writer=params[:writer]
		@movie.title=title
		@movie.sunopsis=synopsis
	  @movie.genres.delete_all
	  @genres=params[:genre_ids]
		 if @movie.save 
			 if @genres
			  @genres.each do |g|
			   if g!=''
				@genre = Genre.find(g)
				@genre.movies << @movie
			   end
			  end
			end
		 end
		 flash[:notice] = "Movie saved"
		 redirect_to @movie
	  else
				flash[:error] = "Error when saving"
		 render 'edit'
	  end
	end
  end

  # DESTROY
  def destroy
		@movie = Movie.find(params[:id])
  		org_name = @movie.poster
		begin
			File.delete(Rails.root.join('public', 'images', org_name));
		rescue => ex
		end
    @movie.destroy
				flash[:notice] = "Movie deleted"
		redirect_to movies_path
  end
	
	# API call
  def call_api
  id = params[:id]
	tt = params[:imdb]
	if tt;	else 	tt='';	end
	url = 'http://www.omdbapi.com/?r=json&i='+tt
	begin
		response = RestClient.get(url)
		result = JSON.parse(response)
		if result["Response"]=="True"
			if params[:'lookup_api_edit.x']
				redirect_to edit_movie_path(:id=>id, :result=>result["Response"], :imdb_i=>tt, :synopsis=>result["Plot"], :title_i=>result["Title"], :year_i=>result["Year"], :director=>result["Director"], :writer=>result["Writer"], :actors=>result["Actors"], :genres_i=>result["Genre"], :poster=>result["Poster"])
			end
			if params[:'lookup_api_new.x']
				redirect_to new_movie_path(:result=>result["Response"], :imdb_i=>tt, :synopsis=>result["Plot"], :title_i=>result["Title"], :year_i=>result["Year"], :director=>result["Director"], :writer=>result["Writer"], :actors=>result["Actors"], :genres_i=>result["Genre"], :poster=>result["Poster"])
			end
		else 		
			if params[:'lookup_api_edit.x']
				redirect_to edit_movie_path(:id=>id, :result=>result["Response"])
			end
			if params[:'lookup_api_new.x']
				redirect_to new_movie_path(:result=>result["Response"])
			end
		end
				flash[:notice] = "Data retrieved"
	rescue => ex
		flash[:error] = "Connection error. Check internet connection."		
		if params[:'lookup_api_edit.x']
			redirect_to edit_movie_path(:id=>id, :result=>"False")
		end
		if params[:'lookup_api_new.x']
			redirect_to new_movie_path(:result=>"False")
		end
	end
  end
	helper_method :call_api
  
	def list_layout
		"list"
	end
  # PRIVATES
  private

    def movie_params
      params.require(:movie).permit(:title, :sub_title, :num_title, :part, :director, :poster, :writer, :actor, :genre_ids, :imdb, :postgres, :sunopsis, :last_seen, :watch_count, :own, :mtype_id, :myear_id, :mformat_id, :quality_id, :mlanguage_id, :msubtitle_id, :threed_id)
    end
	def sort_column
		params[:sort] || Rails.configuration.m_sort || "title"
	end
	def sort_direction
		params[:direction] || Rails.configuration.m_dir || "asc"
	end
end
