class ManufacturersController < ApplicationController
	require 'will_paginate/array'
def index
		@manufacturers = Manufacturer.all.order('m_name ASC').paginate(:page => params[:page], :per_page => 25)
	end
	def show
		@manufacturer = Manufacturer.find(params[:id])
		@parts= @manufacturer.parts.order('part_number ASC')
	end
	def edit
		@manufacturer = Manufacturer.find(params[:id])
	end
	def new
		@manufacturer = Manufacturer.new
	end
	# CREATE
	def create
		@p = Manufacturer.search_name(params[:manufacturer][:m_name]).first
	if @p
		flash[:error] = "Manufacturer already exists. Editing instead."
		redirect_to edit_manufacturer_path(:id=>@p.id)
	else
  		uploaded_io = params[:manufacturer][:logo]
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
		
		@manufacturer = Manufacturer.new(params.require(:manufacturer).permit(:m_name, :m_full_name, :m_description, :m_address, :m_email, :m_website, :m_note, :logo))
		if uploaded_io or web_url; @manufacturer.logo = file_name; end
		@manufacturer.save
		if @manufacturer.save
			flash[:notice] = "Manufacturer created"
			redirect_to @manufacturer
		else 
			flash[:error] = "Error saving"
			render 'new'
		end
	end
	end
	# DESTROY
	def destroy
		@manufacturer = Manufacturer.find(params[:id])
		@manufacturer.destroy
		flash[:notice] = "Manufacturer deleted"
		redirect_to manufacturers_path
	end
	# UPDATE
	def update
		@manufacturer = Manufacturer.find(params[:id])
		
  		file_name = @manufacturer.logo
  		org_name = @manufacturer.logo
		del = params[:del_photo]
  		uploaded_io = params[:manufacturer][:logo]
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

		if @manufacturer.update(params.require(:manufacturer).permit(:m_name, :m_full_name, :m_description, :m_address, :m_email, :m_website, :m_note, :logo))
		 if del 
			file_name=nil
			File.delete(Rails.root.join('public', 'images', org_name))
			end
		 if del or uploaded_io or web_url
			@manufacturer.logo = file_name
			@manufacturer.save
		 end
		flash[:notice] = "Manufacturer saved"
		 redirect_to @manufacturer
		else 
			flash[:error] = "Error when saving"
		 render 'edit'
		end
	end
	def import
		@file = params[:file]
		@fcsv = false
		if @file; @fcsv = File.extname(@file.path)=='.csv' ? true : false; end
		if @file && @fcsv
			Manufacturer.import(params[:file])
			flash[:notice] = "Import completed"
			else 
				flash[:error] = "Import failed"
			end
		redirect_to manufacturers_path
	end
end
