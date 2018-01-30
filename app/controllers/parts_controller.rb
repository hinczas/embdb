class PartsController < ApplicationController
	require 'will_paginate/array'
	require 'open-uri'
	require 'uri'
	helper_method :sort_column, :sort_direction
	def index
		@parts = Part.order(sort_column+' '+sort_direction).all.paginate(:page => params[:page], :per_page => 25)
		if params[:search]
			@parts = Part.search3(params[:search]).sort_by(&:"#{sort_column}").paginate(:page => params[:page], :per_page => 25)
		else
			@parts = Part.order(sort_column+' '+sort_direction).all.paginate(:page => params[:page], :per_page => 25)
		end
		Rails.configuration.p_sort = sort_column 
		Rails.configuration.p_dir = sort_direction 
		
		respond_to do |format|
		  format.html
		  format.csv { send_data @parts.to_csv, filename: "buy-parts-#{Date.today}.csv" }
		  format.tsv { send_data Part.all.all_csv, filename: "all-parts-#{Date.today}.csv" }
		end  
	end
	
	def show
		@part = Part.find(params[:id]) 
	end
	def edit
		@part = Part.find(params[:id])
	end
	def new
		@part = Part.new
	end
	# CREATE
	def create
		@p = Part.search_number(params[:part][:part_number]).first
	if @p
		redirect_to edit_part_path(:id=>@p.id)
		flash[:error] = "Part already exists. Editing instead."
	else
		uploaded_io = params[:part][:file_1]
  		web_url = params[:web_photo]
		if web_url!=''
			uri = URI.parse(web_url)
			file_name= File.basename(uri.path)
			begin
				download = open(web_url)
				IO.copy_stream(download, 'public/uploads/'+file_name)
			rescue => ex
				flash[:error] = "Invalid url for datasheet file. Image not found"
				web_url=nil
			end
		else 
			if uploaded_io
				file_name = uploaded_io.original_filename
				File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
				file.write(uploaded_io.read)
			 end
			end		
		end
		uploaded_ii = params[:part][:file_lbr]
  		web_url2 = params[:web_photo2]
		if web_url2!=''
			uri2 = URI.parse(web_url2)
			file_name2= File.basename(uri2.path)
			begin
				download2 = open(web_url2)
				IO.copy_stream(download2, 'public/uploads/'+file_name2)
			rescue => ex
				flash[:error] = "Invalid url for LBR file. Image not found"
				web_url2=nil
			end
		else 
			if uploaded_ii
				file_name2 = uploaded_ii.original_filename
				File.open(Rails.root.join('public', 'uploads', uploaded_ii.original_filename), 'wb') do |file|
				file.write(uploaded_ii.read)
			 end
			end		
		end
		@part = Part.new(params.require(:part).permit(:part_number, :part_name, :p_type, :p_description, :keywords, :voltage, :current, :p_price, :p_note, :p_quantity, :p_pin_count, :package_id, :location_id, :manufacturer_id, :type_id))
		if uploaded_io or web_url; @part.file_1 = file_name; end
		if uploaded_ii or web_url2; @part.file_lbr = file_name2; end
		if @part.save
		flash[:notice] = "Part created"
		redirect_to @part
		else 
		flash[:error] = "Error when saving"
		render :new
		end
	end
	end
	
	
	def destroy
		@part = Part.find(params[:id])
		if PartPcb.exists?(:part_id => @part.id)
			flash[:error]="Part is used in PCB. Remove it there first."
			redirect_to @part
		else
			@part.destroy
			redirect_to parts_path
		end
	end
	
	
	# ###### #
	# UPDATE #
	# ###### #
	def update
		@part = Part.find(params[:id])
		del_file = params[:del_file_1]
		del_lbr = params[:del_file_lbr]
		uploaded_io = params[:part][:file_1]
  		web_url = params[:web_photo]
  		file_name = @part.file_1
  		file_name2 = @part.file_lbr
  		org_name = @part.file_1
  		org_name2 = @part.file_lbr
		if web_url!=''
			uri = URI.parse(web_url)
			file_name= File.basename(uri.path)
			begin
				download = open(web_url)
				IO.copy_stream(download, 'public/uploads/'+file_name)
			rescue => ex
				flash[:error] = "Invalid url for datasheet file. Image not found"
				web_url=nil
			end
		else 
			if uploaded_io
				file_name = uploaded_io.original_filename
				File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
				file.write(uploaded_io.read)
			 end
			end		
		end
		uploaded_ii = params[:part][:file_lbr]
  		web_url2 = params[:web_photo2]
		if web_url2!=''
			uri2 = URI.parse(web_url2)
			file_name2= File.basename(uri2.path)
			begin
				download2 = open(web_url2)
				IO.copy_stream(download2, 'public/uploads/'+file_name2)
			rescue => ex
				flash[:error] = "Invalid url for LBR file. Image not found"
				web_url2=nil
			end
		else 
			if uploaded_ii
				file_name2 = uploaded_ii.original_filename
				File.open(Rails.root.join('public', 'uploads', uploaded_ii.original_filename), 'wb') do |file|
				file.write(uploaded_ii.read)
			 end
			end		
		end
		if @part.update(params.require(:part).permit(:part_number, :part_name, :p_type, :p_description, :keywords, :voltage, :current, :p_price, :p_note, :p_quantity, :p_pin_count, :package_id, :location_id, :manufacturer_id, :type_id))
		 if del_file; file_name=nil;File.delete(Rails.root.join('public', 'uploads', org_name)); end
		 if del_file or uploaded_io or web_url
			@part.file_1 = file_name
		 end
		 if del_lbr; file_name2=nil;File.delete(Rails.root.join('public', 'uploads', org_name2)); end
		 if del_lbr or uploaded_ii or web_url2
			@part.file_lbr = file_name2
		 end
		 @part.save
		flash[:notice] = "Part saved"
		 redirect_to @part
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
			Part.import(params[:file])
			flash[:notice] = "Import completed"
			else 
			flash[:error] = "Import failed"
			end
		redirect_to parts_path
	end
	def move_location
		id = params[:id]
		new_location=params[:new_location]
		new_location=nil if new_location.blank?
		if id.blank?
		@parts=Part.searchemptyl
		else		
		@parts=Part.searchl(id)
		end
		@parts.update_all(location_id: new_location)
		flash[:notice] = "Move done"
		redirect_to locations_path
	end
	helper_method :move_location
	
	def move_manufacturer
		id = params[:id]
		new_manufacturer=params[:new_manufacturer]
		id = nil if id.blank?
		new_manufacturer=nil if new_manufacturer.blank?
		if id.blank?
		@parts=Part.searchemptym
		else		
		@parts=Part.searchm(id)
		end
		@parts.update_all(manufacturer_id: new_manufacturer)
		flash[:notice] = "Move done"
		redirect_to manufacturers_path
	end
	helper_method :move_manufacturer
	
	def move_package
		id = params[:id]
		new_package=params[:new_package]
		id = nil if id.blank?
		new_package=nil if new_package.blank?
		if id.blank?
		@parts=Part.searchemptyp
		else		
		@parts=Part.searchp(id)
		end
		@parts.update_all(package_id: new_package)
		flash[:notice] = "Move done"
		redirect_to packages_path
	end
	helper_method :move_package
	
	def move_type
		id = params[:id]
		new_type=params[:new_type]
		id = nil if id.blank?
		new_type=nil if new_type.blank?
		if id.blank?
		@parts=Part.searchemptyt
		else		
		@parts=Part.searcht(id)
		end
		@parts.update_all(type_id: new_type)
		flash[:notice] = "Move done"
		redirect_to types_path
	end
	helper_method :move_type
	
	def add_qte
		part=Part.find(params[:id])
		part.increment!(:p_quantity)
		redirect_to parts_path
	end
	helper_method :add_qte
	
	def del_qte
		part=Part.find(params[:id])
		part.decrement!(:p_quantity)
		redirect_to parts_path
	end
	helper_method :del_qte
	
	def set_qte
		part=Part.find(params[:id])
		part.p_quantity=params[:p_quantity]
		part.save
		redirect_to part_path(part)
	end
	helper_method :set_qte
	
	def add_qte_s
		part=Part.find(params[:id])
		part.increment!(:p_quantity)
		redirect_to part_path(part)
	end
	helper_method :add_qte_s
	
	def del_qte_s
		part=Part.find(params[:id])
		part.decrement!(:p_quantity)
		redirect_to part_path(part)
	end
	helper_method :del_qte_s
	
	def live_search
	  @parts = Part.search(params[:q])
	  render :layout => false
	end
	
	def download(file_name)
		path = Rails.public_path+'uploads/'+file_name
		send_data(path, :type => 'text/csv', :disposition => "attachment")
	end
	helper_method :download
	
	
	# PRIVATE
	private
	def sort_column
		params[:sort] || Rails.configuration.p_sort || "part_number"	
	end
	def sort_direction
		params[:direction] || Rails.configuration.p_dir || "asc"
	end
end
