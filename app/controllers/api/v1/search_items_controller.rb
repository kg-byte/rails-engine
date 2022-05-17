class Api::V1::SearchItemsController < ApplicationController
  def index
    items = Item.where("lower(name) like ?", "%#{params[:name].downcase}%")
	  render json: Api::V1::ItemSerializer.new(items)
  end

  def show
    item = Item.where("lower(name) like ?", "%#{params[:name].downcase}%").order(:name).first
    if item 
        render json: Api::V1::ItemSerializer.new(item), status: :ok
    else 
      render json: {data: {error: 'Item not found'}}
    end
  end
end