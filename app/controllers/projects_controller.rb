class ProjectsController < ApplicationController
	require 'rails/all'
	require 'will_paginate/array'
	require 'csv'
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all.order("code ASC, version DESC").paginate(:page => params[:page], :per_page => 5)
       
	if params[:search]
		@projects = Project.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page => 5)
	else
		@projects = Project.all.order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page => 5)
	end
		Rails.configuration.pr_sort = sort_column 
		Rails.configuration.pr_dir = sort_direction
	respond_to do |format|
	  format.html
	  format.tsv { send_data Project.all.all_csv, filename: "all-projects-#{Date.today}.csv" }
	end  
	
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
	@project = Project.find(params[:id])
	respond_to do |format|
	  format.html
	  format.csv { send_data Project.mob_csv(id: params[:id]), filename: "project-bom-#{Date.today}.csv" }
	end  
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
  
    @project = Project.new(project_params)
	time = Time.new
	uploaded_io = params[:project][:background]
	file_name="project-background.png"
	if uploaded_io
		file_name=SecureRandom.hex
		File.open(Rails.root.join('public', 'images', 'backgrounds', file_name), 'wb') do |file|
			file.write(uploaded_io.read)
		end
	 end
    respond_to do |format|
      if @project.save
		# Updating PCB quantity
		nums_id=params[:project][:pcb_ids]
			if nums_id
				nums_id.each do |id|
					component='quantity_'+id.to_s
					if id and id!=''
						val = params["quantity_#{id}"]
						@pp=PcbProject.where(project_id: "#{@project.id}", pcb_id: "#{id}").take
						@pp.upd_qte(@pp.id, val)
					end
				end
			end  
		# Updating Part quantity
		parts_id=params[:project][:part_ids]
			if parts_id
				parts_id.each do |id|
					p_component='p_quantity_'+id.to_s
					if id and id!=''
						p_val = params["p_quantity_#{id}"]
						@p_p=PartProject.where(project_id: "#{@project.id}", part_id: "#{id}").take
						@p_p.upd_qte(@p_p.id, p_val)
					end
				end
			end      
		@project.log=time.strftime("%e %b %Y %H:%M")+": Project created\n"
		@project.save
		if params[:image]
		  params[:image].each do |picture|      
			@project.photos.create(:image=> picture)
			# Don't forget to mention :avatar(field name)
			end
		 end
		 # saving files
		 if params[:file]
		  params[:file].each do |file|      
			@project.documents.create(:file=> file)
			# Don't forget to mention :avatar(field name)
			end
		 end
		if params[:text_log]!=""		
			log = time.strftime("%e %b %Y %H:%M")+": "+ params[:text_log]
			@project.log+=log+"\n"
		end
		if uploaded_io; @project.background = file_name; end	
		@project.save
		flash[:notice] = "Project created"
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, error: "Error when saving" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
  params[:parent_id]=params[:project][:parent_id]
		# background saving
		uploaded_io = params[:project][:background]
		del = params[:del_photo]
		org_filename="default.png"
		file_name="project-background.png"
		time = Time.new
		if uploaded_io
			file_name=SecureRandom.hex
			File.open(Rails.root.join('public', 'images',  'backgrounds',file_name), 'wb') do |file|
			file.write(uploaded_io.read)
		 end	
		end
    respond_to do |format|
      if @project.update(project_params)          
		 # saving images
		 if params[:image]
		  params[:image].each do |picture|      
			@project.photos.create(:image=> picture)
			# Don't forget to mention :avatar(field name)
			end
		 end
		 # saving files
		 if params[:file]
		  params[:file].each do |file|      
			@project.documents.create(:file=> file)
			# Don't forget to mention :avatar(field name)
			end
		 end
		 # saving logs
		if params[:text_log]!=""
			log = time.strftime("%e %b %Y %H:%M")+": "+ params[:text_log]
			if @project.log; @project.log+=log+"\n"; else @project.log=log+"\n"; end
		end
		# deleting selected images
		if params[:destruction]
			Photo.where(:project_id=>@project.id).where(:id => params[:destruction]).destroy_all
		end
		# deleting selected files
		if params[:deletions]
			Document.where(:project_id=>@project.id).where(:id => params[:deletions]).destroy_all
		end
		# updating background
		if del
			File.delete(Rails.root.join('public', 'images', 'backgrounds', @project.background))
			file_name=org_filename;
		end
		if uploaded_io or del; @project.background = file_name; end	
		# Updating PCB quantity
		nums_id=params[:project][:pcb_ids]
			if nums_id
				nums_id.each do |id|
					component='quantity_'+id.to_s
					if id and id!=''
						val = params["quantity_#{id}"]
						@pp=PcbProject.where(project_id: "#{@project.id}", pcb_id: "#{id}").take
						@pp.upd_qte(@pp.id, val)
					end
				end
			end    
		# Updating Part quantity
		parts_id=params[:project][:part_ids]
			if parts_id
				parts_id.each do |id|
					p_component='p_quantity_'+id.to_s
					if id and id!=''
						p_val = params["p_quantity_#{id}"]
						@p_p=PartProject.where(project_id: "#{@project.id}", part_id: "#{id}").take
						@p_p.upd_qte(@p_p.id, p_val)
					end
				end
			end  
		# saving all changes
		@project.save
		flash[:notice] = "Project saved"
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
		flash[:error] = "Error when saving project"
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
	org_name = @project.background
	begin
		File.delete(Rails.root.join('public', 'images', 'backgrounds', org_name));
	rescue => ex
	end
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

	def import
		@file = params[:file_imp]
		@fcsv = false
		if @file; @fcsv = File.extname(@file.path)=='.csv' ? true : false; end
		if @file && @fcsv
			Project.import(params[:file_imp])
		flash[:notice] = "Import completed"
		else
		flash[:error] = "Import failed"
			end
		redirect_to projects_path
	end
def del_photos
end
helper_method :del_photos
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:code, :name, :version, :start_date, :end_date, :notes, :description, {:part_ids => []}, {:pcb_ids => []}, :log, :folder_location, :background)
    end
	def sort_column
		params[:sort] || Rails.configuration.pr_sort || "code"
	end
	def sort_direction
		params[:direction] || Rails.configuration.pr_dir || "asc"
	end
end
