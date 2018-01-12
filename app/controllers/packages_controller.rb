class PackagesController < ApplicationController
	require 'will_paginate/array'
	def index
		@packages = Package.all.order('pk_name ASC').paginate(:page => params[:page], :per_page => 25)
	end
	def show
		@package = Package.find(params[:id])
		@parts= @package.parts.order('part_number ASC')
	end
	def edit
		@package = Package.find(params[:id])
	end
	def new
		@package = Package.new
	end
	def create
		@p = Package.search_number(params[:package][:pk_number]).first
	if @p
		flash[:error] = "Package already exists. Editing instead."
		redirect_to edit_package_path(:id=>@p.id)
	else
		uploaded_io = params[:package][:pk_photo]
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
				file_name = uploaded_io.original_filename
				File.open(Rails.root.join('public', 'images', uploaded_io.original_filename), 'wb') do |file|
				file.write(uploaded_io.read)
			 end
			end		
		end
		@package = Package.new(params.require(:package).permit(:pk_number, :pk_name, :pk_description, :pk_note))
		if uploaded_io or web_url; @package.pk_photo = file_name; end
		@package.save
		flash[:notice] = "Package saved"
		redirect_to @package
		end
	end
	def destroy
		@package = Package.find(params[:id])
		@package.destroy
		flash[:notice] = "Package deleted"
		redirect_to packages_path
	end
	def update
		@package = Package.find(params[:id])
		uploaded_io = params[:package][:pk_photo]
		del	=	params[:del_photo]
  		web_url = params[:web_photo]
  		file_name = @package.pk_photo
  		org_name = @package.pk_photo
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
				file_name = uploaded_io.original_filename
				File.open(Rails.root.join('public', 'images', uploaded_io.original_filename), 'wb') do |file|
				file.write(uploaded_io.read)
			 end
			end		
		end

		if @package.update(params.require(:package).permit(:pk_number, :pk_name, :pk_description, :pk_note))
		 if del; file_name=nil;File.delete(Rails.root.join('public', 'images', org_name)); end
		 if del or uploaded_io or web_url
			@package.pk_photo = file_name
		 end
		 @package.save
		flash[:notice] = "Package saved"
		 redirect_to @package
		else 
		 render 'edit'
		end
	end
	def import
		@file = params[:file]
		@fcsv = false
		if @file; @fcsv = File.extname(@file.path)=='.csv' ? true : false; end
		if @file && @fcsv
			Package.import(params[:file])
			flash[:notice] = "Import completed"
			else
				flash[:error] = "Import failed"
			end
		redirect_to packages_path
	end
end
