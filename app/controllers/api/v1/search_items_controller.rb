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
    return render json: {error: 'max_price cannot be negative'}, status:400 if item_params[:max_price].to_i < 0
    return render json: {error: 'min_price cannot be negative'}, status:400 if item_params[:min_price].to_i < 0
    return render json: {data: {error: 'Parameter cannot be missing'}}, status: 400 if item_params == {}
    return render json: {data: {error: 'Parameter cannot be empty'}}, status: 400 if item_params.values.first ==''
    return render json: {data: {error: 'Cannot send both name and max_price'}}, status: 400 if item_params[:name] && item_params[:max_price]
    return render json: {data: {error: 'Cannot send both name and max_price and min_price'}}, status: 400 if item_params[:name] && item_params[:min_price] && item_params[:max_price]
    return render json: {data: {error: 'Cannot send both name and min_price'}}, status: 400 if item_params[:name] && item_params[:min_price]

    if params[:max_price] && params[:min_price] 
      return render json: {data: {error: 'max_price cannot be less than min_price'}}, status: 400 if item_params[:max_price].to_i < item_params[:min_price].to_i
    end
    

    if params[:name] && params[:name] != ''
      item = Item.where("lower(name) like ?", "%#{params[:name].downcase}%").order(:name).first
    elsif params[:min_price] && params[:min_price] != '' && !params[:max_price]
      item = Item.where("unit_price > #{params[:min_price].to_i}").order(:name).first
    elsif params[:max_price] && params[:max_price] != '' && !params[:min_price]
      item = Item.where("unit_price < #{params[:max_price].to_i}").order(:name).first
    elsif params[:max_price] && params[:min_price] && params[:max_price] > params[:min_price]
      item = Item.where(unit_price: params[:min_price].to_i..params[:max_price].to_i).order(:name).first
    end

    if item 
      return render json: Api::V1::ItemSerializer.new(item), status: :ok
    else 
      return render json: {data: {error: 'Item not found'}}
    end
  end

  private
    def item_params
      params.permit(:name, :max_price, :min_price)
    end
end