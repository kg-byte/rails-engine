class Api::V1::SearchItemsController < ApplicationController
  def index
    if params[:name] && params[:name] != ''
      items = Item.where("lower(name) like ?", "%#{params[:name].downcase}%")
	    render json: Api::V1::ItemSerializer.new(items)
    end
    render json: {data: {error: 'Parameter cannot be missing'}}, status: 400 if item_params == {}
    render json: {data: {error: 'Parameter cannot be empty'}}, status: 400 if item_params.values.first ==''
  end

  def show
    if params[:name] && params[:name] != ''
      item = Item.where("lower(name) like ?", "%#{params[:name].downcase}%").order(:name).first
      if item 
          render json: Api::V1::ItemSerializer.new(item), status: :ok
      else 
        render json: {data: {error: 'Item not found'}}
      end
    end
      render json: {data: {error: 'Parameter cannot be missing'}}, status: 400 if item_params == {}
      render json: {data: {error: 'Parameter cannot be empty'}}, status: 400 if item_params.values.first ==''
  end

  private
    def item_params
      params.permit(:name, :max_price, :min_price)
    end
end