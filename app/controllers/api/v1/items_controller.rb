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

private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end