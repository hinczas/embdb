class TypesController < ApplicationController
	require 'will_paginate/array'
	def index
		@types = Type.all.order('name ASC').paginate(:page => params[:page], :per_page => 25)
	end
	def show
		@type = Type.find(params[:id])
		@parts= @type.parts.order('part_number ASC')
	end
	def edit
		@type = Type.find(params[:id])
	end
	def new
		@type = Type.new
	end
	def create
		@p = Type.search_name(params[:type][:name]).first
		if @p
			redirect_to edit_type_path(:id=>@p.id)
			flash[:error] = "Type already exists. Editing instead."
		else
			@type = Type.new(params.require(:type).permit(:name, :t_description, :t_note))
			@type.save
			flash[:notice] = "Type created"
			redirect_to @type
		end
	end
	def destroy
		@type = Type.find(params[:id])
		@type.destroy
			flash[:notice] = "Type deleted"
		redirect_to types_path
	end
	def update
		@type = Type.find(params[:id])

		if @type.update(params.require(:type).permit(:name, :t_description, :t_note))
			flash[:notice] = "Type updated"
		 redirect_to @type
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
			Type.import(params[:file])
			flash[:notice] = "Import completed"
			else
			flash[:error] = "Import failed"			
			end
		redirect_to types_path
	end
end
