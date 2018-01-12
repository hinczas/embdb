class BooksController < ApplicationController
	require 'will_paginate/array'
	
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.all.order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page => 27)
    
    if params[:layout]
			Rails.configuration.books_layout=params[:layout]
	end
	if params[:search]
		@books = Book.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page => 27)
	else
		@books = Book.all.order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page => 27)
	end
		Rails.configuration.b_sort = sort_column 
		Rails.configuration.b_dir = sort_direction 		
	respond_to do |format|
	  format.html
	  format.tsv { send_data Book.all.all_csv, filename: "all-books-#{Date.today}.csv" }
	end  
  end

  def show
	@book = Book.find(params[:id])
  end

  def new
    @book = Book.new
    @authors = Author.all
  end

  def edit
	@book = Book.find(params[:id])
  end

  def create
  		uploaded_io = params[:book][:cover]
  		web_url = params[:web_photo]
		if web_url!=''
			file_name=SecureRandom.hex
			begin
				download = open(web_url)
				IO.copy_stream(download, 'public/images/'+file_name)
			rescue => ex
				flash[:error] = "Invalid url. Image not found"
			end
		else 
			if uploaded_io
				file_name=SecureRandom.hex
				File.open(Rails.root.join('public', 'images', file_name), 'wb') do |file|
				file.write(uploaded_io.read)
			 end
			end		
		end
		@book = Book.new(book_params)
		if uploaded_io or web_url; @book.cover = file_name; end		
		@authors=params[:author_ids]
		if @book.save 
		 if @authors
		  @authors.each do |g|
		   if g!=''
			@author = Author.find(g)
			@author.books << @book
		   end
		  end
		 end
				flash[:notice] = "Book saved"
		else 
			render :new
		end
		redirect_to @book	
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
  
		@book = Book.find(params[:id])
		uploaded_io = params[:book][:cover]
		del = params[:del_photo]
  		web_url = params[:web_photo]
  		file_name = @book.cover
  		org_name = @book.cover
		if web_url!=''
			file_name=SecureRandom.hex
			begin
				download = open(web_url)
				IO.copy_stream(download, 'public/images/'+file_name)
			rescue => ex
				flash[:notice] = "Invalid url. Image not found"
			end
		else 
			if uploaded_io
				file_name=SecureRandom.hex
				File.open(Rails.root.join('public', 'images', file_name), 'wb') do |file|
				file.write(uploaded_io.read)
			 end
			end		
		end

		if @book.update(book_params)
		 if del; file_name=nil;File.delete(Rails.root.join('public', 'images', org_name)); end
		 if del or uploaded_io or web_url
			@book.cover = file_name
		 end
	    @book.authors.delete_all
		@authors=params[:author_ids]
		 if @authors
		  @authors.each do |g|
		   if g!=''
			@author = Author.find(g)
			@author.books << @book
		   end
		  end
		 end
		 flash[:notice] = "Book saved"
		 @book.save		 
		 redirect_to @book
		else 
		 render 'edit'
		end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
  		org_name = @book.cover
  		begin
  		 File.delete(Rails.root.join('public', 'images', org_name));
  		 rescue => ex
  		end
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book deleted" }
      format.json { head :no_content }
    end
  end
	def import
		@file = params[:file]
		@fcsv = false
		if @file; @fcsv = File.extname(@file.path)=='.csv' ? true : false; end
		if @file && @fcsv
			Book.import(params[:file])
				flash[:notice] = "Import complete"
			else
				flash[:error] = "Import failed"
			end
		redirect_to books_path
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :subtitle, :series, :isbn, :language, :sunopsis, :cover, :user_id, :cover_typ, :author_ids, :year, :notes, :author_id, :publisher_id)
    end
	def sort_column
		params[:sort] || Rails.configuration.b_sort || "title"
	end
	def sort_direction
		params[:direction] || Rails.configuration.b_dir || "asc"
	end
end
