class Api::V1::ItemsController < ApplicationController
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
    if valid_merchant_id
      render json: Api::V1::ItemSerializer.new(Item.update(params[:id], item_params))
    else 
      render :status => 404
    end
  end

  def destroy 
    render json: Item.delete(params[:id])
  end
  
private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def page_num
    params[:page]? params[:page] : 1
  end

  def num_per_page
    params[:per_page]? params[:per_page] : 20
  end

  def valid_merchant_id
    Merchant.id_exist?(params[:merchant_id]) || !item_params[:merchant_id]
  end
end