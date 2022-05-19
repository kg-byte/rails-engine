class Api::V2::ItemsController < ApplicationController
  before_action :authenticate_with_api_key!
  include ParamsHelper, ApiKeyAuthenticatable
  def index
    items = Item.all.paginate(page: page_num, per_page: num_per_page)
    render json: Api::V1::ItemSerializer.new(items)
  end

  def show
  	render json: Api::V1::ItemSerializer.new(Item.find(params[:id]))
  end

  def create 
    render json: Api::V1::ItemSerializer.new(Item.create(item_params)), status: :created
  end

  def update 
    render json: Api::V1::ItemSerializer.new(Item.update(params[:id], item_params)) if valid_merchant_id
    render status: 404 if !valid_merchant_id
  end

  def destroy 
    item = Item.find(params[:id])
    item.destroy_single_invoices
    render json: Item.delete(params[:id])
  end
  
private

  def valid_merchant_id
    Merchant.id_exist?(params[:merchant_id]) || !item_params[:merchant_id]
  end
end