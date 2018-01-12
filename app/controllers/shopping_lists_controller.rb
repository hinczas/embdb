class ShoppingListsController < ApplicationController
	require 'will_paginate/array'
	require 'open-uri'
	require 'uri'
	
  before_action :set_shopping_list, only: [:show, :edit, :update, :destroy]

  # GET /shopping_lists
  # GET /shopping_lists.json
  def index
    @shopping_lists = ShoppingList.all_csv
    
	if params[:search]
		@shopping_lists = ShoppingList.search(params[:search])
	else
		@shopping_lists = ShoppingList.all_csv
	end
	respond_to do |format|
		@lists = ShoppingList.all_csv
	  format.html
	  format.csv { send_data ShoppingList.export_csv, filename: "all-basket-#{Date.today}.csv" }
	end  
  end

  # GET /shopping_lists/1
  # GET /shopping_lists/1.json
  def show
  end

  # GET /shopping_lists/new
  def new
    @shopping_list = ShoppingList.new
  end

  # GET /shopping_lists/1/edit
  def edit
  end

  # POST /shopping_lists
  # POST /shopping_lists.json
  def create
  session[:return_to] ||= request.referer
	  if params[:shopping_list][:item_update]
		#ShoppingList.all_parts.each do |ap|
		params[:shopping_list][:item_ids].each do |ap|
			item_id=ap	
			item_qte = Integer(params[:shopping_list]["item_quantity_#{item_id}"])
			item_del = Integer(params[:shopping_list]["item_del_#{item_id}"])
			cur_qte=Integer(ShoppingList.cur_qte(item_id).first.item_quantity)
			new_qte=item_qte-cur_qte
			if item_qte!=cur_qte or item_del == 1
				if item_qte == 0 or item_del == 1
					ShoppingList.where("item_id = #{item_id}").destroy_all
				else
					list=ShoppingList.new(item_id: item_id, item_type: 'part', item_quantity: new_qte)
					list.save!
				end
			end
		end	
		redirect_to session.delete(:return_to), notice: 'Items updated.'
	  else	  
		  if params[:shopping_list][:item_add_all]
		  ids = params[:shopping_list][:item_ids]
				ids.each do |id|
					qte = Integer(params[:shopping_list]["item_quantity_#{id}"])				
					if qte == 0
					else
						list=ShoppingList.new(item_id: id, item_type: 'part', item_quantity: qte)
						list.save!
					end
				end
			redirect_to session.delete(:return_to), notice: 'Items added.'
		  else
			@shopping_list = ShoppingList.new(shopping_list_params)
			respond_to do |format|
			  if @shopping_list.save
				format.html { redirect_to session.delete(:return_to), notice: 'Items added to shopping list.' }
			  else
				format.html { redirect_to session.delete(:return_to), error: 'Adding to list failed' }
			  end
			end
		  end
	  end
  end

  # PATCH/PUT /shopping_lists/1
  # PATCH/PUT /shopping_lists/1.json
  def update
    respond_to do |format|
      if @shopping_list.update(shopping_list_params)
        format.html { redirect_to @shopping_list, notice: 'Shopping list was successfully updated.' }
        format.json { render :show, status: :ok, location: @shopping_list }
      else
        format.html { render :edit }
        format.json { render json: @shopping_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shopping_lists/1
  # DELETE /shopping_lists/1.json
  def destroy
    @shopping_list.destroy
    respond_to do |format|
      format.html { redirect_to shopping_lists_url, notice: 'Shopping list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
	
	def upd_all(list)
		session[:return_to] ||= request.referer
		@list= list
		@list.each do |p|
				ShoppingList.create(item_update: 1, item_id: p.id, item_type: 'part', item_quantity:0)
			 end 
		 redirect_to session.delete(:return_to)
	end
	helper_method :add_all
	
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_list
      @shopping_list = ShoppingList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shopping_list_params
      params.require(:shopping_list).permit(:item_update, :item_add_all, :item_ids, :item_id, :item_type, :item_quantity, {:item_ids => []})
    end
end
