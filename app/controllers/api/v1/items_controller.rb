class Api::V1::ItemsController < ApplicationController
  def index
  	render json: Api::V1::ItemSerializer.new(Item.all)
  end

  def show
  	render json: Api::V1::ItemSerializer.new(Item.find(params[:id]))
  end

  def create 
    render json: Api::V1::ItemSerializer.new(Item.create(item_params)), status: :created
  end

  def update 
    if Merchant.pluck(:id).include?(params[:merchant_id]) || !item_params[:merchant_id]
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
end