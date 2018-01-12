class PcbsController < ApplicationController
	require 'will_paginate/array'
  before_action :set_pcb, only: [:show, :edit, :update, :destroy]


  # GET /pcbs
  # GET /pcbs.json
  def index
    @pcbs = Pcb.all.order("name ASC, version DESC").paginate(:page => params[:page], :per_page => 25)
        
	if params[:search]
		@pcbs = Pcb.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page => 25)
	else
		@pcbs = Pcb.all.order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page => 25)
	end
		Rails.configuration.pcb_sort = sort_column 
		Rails.configuration.pcb_dir = sort_direction 
	respond_to do |format|
	  format.html
	  format.tsv { send_data Pcb.all.all_csv, filename: "all-pcbs-#{Date.today}.csv" }
	end  
  end

  # GET /pcbs/1
  # GET /pcbs/1.json
  def show
	@pcb = Pcb.find(params[:id])
	respond_to do |format|
	  format.html
	  format.csv { send_data Pcb.mob_csv(id: params[:id]), filename: "pcb-bom-#{Date.today}.csv" }
	end 
  end

  # GET /pcbs/new
  def new
    @pcb = Pcb.new
  end

  # GET /pcbs/1/edit
  def edit
  end

  # POST /pcbs
  # POST /pcbs.json
  def create
	p_name = params[:pcb][:name].downcase
	total_cost=0
    @pcb = Pcb.new(pcb_params)
	time = Time.new
	uploaded_io = params[:pcb][:file_1]
	if uploaded_io
		file_name = uploaded_io.original_filename
		if file_name.downcase.exclude? p_name
				flash[:error]= "PCB name must be part of SCH file name!"
				redirect_to edit_pcb_url and return
		end
			file_path = File.absolute_path(uploaded_io.original_filename)
	end		
	uploaded_ii = params[:pcb][:file_lbr]
	if uploaded_ii
		file_name2 = uploaded_ii.original_filename
			if file_name2.downcase.exclude? p_name
				flash[:error]= "PCB name must be part of Board file name!"
				redirect_to edit_pcb_url and return
			end
			file_path2 = File.absolute_path(uploaded_ii.original_filename)
	end	
	uploaded_ph = params[:pcb][:photo_path] 
	if uploaded_ph
		file_name3=SecureRandom.hex
		File.open(Rails.root.join('public', 'images', file_name3), 'wb') do |file|
		file.write(uploaded_ph.read)
	 end
	end
	if @pcb.save 
		if params[:parent_id]
			@pcb.parent_id=params[:parent_id]
		end
		nums_id=params[:pcb][:part_ids]
			if nums_id
				nums_id.each do |id|
					component='quantity_'+id.to_s
					if id and id!=''
						val = params["quantity_#{id}"]
						@pb=PartPcb.where(pcb_id: "#{@pcb.id}", part_id: "#{id}").take
						@pb.upd_qte(@pb.id, val)
					end
				end
			end
		if uploaded_io; @pcb.sch_file = file_path; end
		if uploaded_ii; @pcb.brd_file = file_path2; end
		if uploaded_ph; @pcb.photo = file_name3; end
		@pcb.changelog=time.strftime("%e %b %Y %H:%M")+" PCB created\n"
		if params[:text_log]!=""
			log = params[:date_log] +": "+ params[:text_log]
			@pcb.changelog+=log+"\n"
		end
	  @pcb.save 
		flash[:notice] = "PCB created"
		redirect_to @pcb
	else 
		flash[:error] = "Error when saving"
		render :new
	end
  end

	def import
		@file = params[:file]
		@fcsv = false
		if @file; @fcsv = File.extname(@file.path)=='.csv' ? true : false; end
		if @file && @fcsv
			Pcb.import(params[:file])
		flash[:notice] = "Import completed"
		else
		flash[:error] = "Import failed"
			end
		redirect_to pcbs_path
	end
	
  # PATCH/PUT /pcbs/1
  # PATCH/PUT /pcbs/1.json
  def update
	p_name = params[:pcb][:name].downcase
		time = Time.new
		del_file = params[:del_file_1]
		del_lbr = params[:del_file_lbr]
		del_photo = params[:del_photo]
		uploaded_io = params[:pcb][:file_1]
  		file_name = @pcb.sch_file
  		file_name2 = @pcb.brd_file
  		org_name = @pcb.sch_file
  		org_name2 = @pcb.brd_file
  		file_name3 = @pcb.photo
  		org_name3 = @pcb.photo
		if uploaded_io
			file_name = uploaded_io.original_filename
			if file_name.downcase.exclude? p_name
				flash[:error]= "PCB name must be part of Schematics file name!"
				redirect_to edit_pcb_url and return
			end
			file_path = File.absolute_path(uploaded_io.original_filename)
		end	
		uploaded_ii = params[:pcb][:file_lbr]
		if uploaded_ii
			file_name2 = uploaded_ii.original_filename
			if file_name2.downcase.exclude? p_name
				flash[:error]= "PCB name must be part of Board file name!"
				redirect_to edit_pcb_url and return
			end
			file_path2 = File.absolute_path(uploaded_ii.original_filename)
		end	
		uploaded_ph = params[:pcb][:photo_path]
		if uploaded_ph
			file_name3=SecureRandom.hex
			File.open(Rails.root.join('public', 'images', file_name3), 'wb') do |file|
			file.write(uploaded_ph.read)
		 end
		end	
      if @pcb.update(pcb_params)
		 if del_file; file_name=nil; end
		 if del_file or uploaded_io
			@pcb.sch_file = file_path
		 end
		 if del_lbr; file_name2=nil; end
		 if del_lbr or uploaded_ii
			@pcb.brd_file = file_path2
		 end
		 if del_photo; file_name3=nil;File.delete(Rails.root.join('public', 'images', org_name3)); end
		 if del_photo or uploaded_ph
			@pcb.photo = file_name3
		 end
		nums_id=params[:pcb][:part_ids]
		if nums_id
			nums_id.each do |id|
				component='quantity_'+id.to_s
				if id and id!=''
					val = params["quantity_#{id}"]
					@pb=PartPcb.where(pcb_id: "#{@pcb.id}", part_id: "#{id}").take
					@pb.upd_qte(@pb.id, val)
				end
			end
		end
		total_cost=0
		if @pcb.save 
		if params[:parent_id]
			if params[:parent_id]!="" and (Pcb.find(params[:parent_id]).version > params[:pcb][:version])
				flash[:error] = "Previous pcb can not be newer version!"
				render :edit and return
			else 
				@pcb.parent_id=params[:parent_id]
			end
		end		 
		if params[:text_log]!=""
			log = params[:date_log] +": "+ params[:text_log]
			@pcb.changelog+=log+"\n"
		end
		 @pcb.save 
		flash[:notice] = "PCB saved"
		redirect_to @pcb
		 end
		else 
		flash[:error] = "Error when saving"
			render :edit
		end
  end
  
	def live_search
	  @pcbs = Pcb.lookup(params[:pcb_name], params[:id])
	  render :layout => false
	end
	
  # DELETE /pcbs/1
  # DELETE /pcbs/1.json
  def destroy
  if PcbProject.exists?(:pcb_id=>@pcb.id)
	flash[:error]="PCB is used in a project. Remove from project first"
	redirect_to @pcb
	else
  		org_name = @pcb.sch_file
  		org_name2 = @pcb.brd_file
  		org_name3 = @pcb.photo
  		begin
  		 File.delete(Rails.root.join('public', 'images', org_name));
  		 rescue => ex
  		end
  		begin
  		 File.delete(Rails.root.join('public', 'images', org_name2));
  		 rescue => ex
  		end
  		begin
  		 File.delete(Rails.root.join('public', 'images', org_name3));
  		 rescue => ex
  		end
		@pcb.destroy
		respond_to do |format|
		  format.html { redirect_to pcbs_url, notice: 'Pcb deleted' }
		  format.json { head :no_content }
		end
	end
  end


	def add_all	
		session[:return_to] ||= request.referer
		@pcb= Pcb.find(params[:id])
		@pcb.parts.each do |p|
			 if PartPcb.where(pcb_id: @pcb.id, part_id: p.id).take.quantity > if p.p_quantity; p.p_quantity; else; 0; end; 
				@itm_id=p.id			
				@item_quantity=(PartPcb.where(pcb_id: @pcb.id, part_id: p.id).take.quantity-(if p.p_quantity; p.p_quantity; else; 0; end;))
				@item_type='part'
				list=ShoppingList.new(item_id: p.id, item_type: 'part', item_quantity: @item_quantity)
				list.save!
			 end 
		 end 
		 redirect_to session.delete(:return_to)
	end
	helper_method :add_all

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pcb
      @pcb = Pcb.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pcb_params
      params.require(:pcb).permit(:name, :version, :start_date, :end_date, :photo, :notes, :cost, {:part_ids => []}, :changelog, :sch_file, :brd_file, :parent_id)
    end
	def sort_column
		params[:sort] || Rails.configuration.pcb_sort || "name"
	end
	def sort_direction
		params[:direction] || Rails.configuration.pcb_dir || "asc"
	end
end
