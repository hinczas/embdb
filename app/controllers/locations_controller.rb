class LocationsController < ApplicationController
	require 'will_paginate/array'
	def index
		@locations = Location.all.order('l_name ASC').paginate(:page => params[:page], :per_page => 25)
	end
	def show
		@location = Location.find(params[:id])
		@parts= @location.parts.order('part_number ASC')
	end
	def edit
		@location = Location.find(params[:id])
	end
	def new
		@location = Location.new
	end
	def create
		@p = Location.search_name(params[:location][:l_name]).first
		if @p
			redirect_to edit_location_path(:id=>@p.id)
			flash[:error] = "Location already exists. Editing instead."
		else
			uploaded_io = params[:location][:l_photo]
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
					# file_name = uploaded_io.original_filename
					file_name = SecureRandom.hex
					File.open(Rails.root.join('public', 'images', file_name), 'wb') do |file|
					file.write(uploaded_io.read)
				 end
				end		
			end
			@location = Location.new(params.require(:location).permit(:l_name, :l_description, :l_note))
			if uploaded_io or web_url; @location.l_photo = file_name; end
			@location.save
			flash[:notice] = "Location saved"
			redirect_to @location
		end
	end
	def destroy
		@location = Location.find(params[:id])
  		org_name = @location.l_photo
		begin
			File.delete(Rails.root.join('public', 'images', org_name));
		rescue => ex
		end
		@location.destroy
		flash[:notice] = "Location deleted"
		redirect_to locations_path
	end
	def update
		@location = Location.find(params[:id])
		uploaded_io = params[:location][:l_photo]
		del = params[:del_photo]
  		web_url = params[:web_photo]
  		file_name = @location.l_photo
  		org_name = @location.l_photo
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
					file_name = SecureRandom.hex
					File.open(Rails.root.join('public', 'images', file_name), 'wb') do |file|
					file.write(uploaded_io.read)
			 end
			end		
		end

		if @location.update(params.require(:location).permit(:l_name, :l_description, :l_note))
		 if del; file_name=nil;File.delete(Rails.root.join('public', 'images', org_name)); end
		 if del or uploaded_io or web_url
			@location.l_photo = file_name
		 end
		 @location.save
		flash[:notice] = "Location saved"
		 redirect_to @location
		else 
		 render 'edit'
		end
	end
	def import
		@file = params[:file]
		@fcsv = false
		if @file; @fcsv = File.extname(@file.path)=='.csv' ? true : false; end
		if @file && @fcsv
			Location.import(params[:file])
			flash[:notice] = "Import complete"
			else
			flash[:error] = "Import error"
		end
		redirect_to locations_path
	end
end
