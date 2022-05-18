class Api::V1::SearchItemsController < ApplicationController
  def index
    if edge_cases_conditions
      edge_case_resposne
    else
	    render json: Api::V1::ItemSerializer.new(search_items)
    end
  end

  def show
    if edge_cases_conditions
      edge_case_resposne
    else
      render json: Api::V1::ItemSerializer.new(search_one_item), status: :ok if search_one_item
      render json: {data: {error: 'Item not found'}} if !search_one_item
    end
  end

  private
    def item_params
      params.permit(:name, :max_price, :min_price)
    end

    def edge_cases_conditions
      negative_max || negative_min || no_params || empty_params || name_and_price || max_less_than_min
    end

    def edge_case_resposne
      return render json: Api::V1::ErrorSerializer.val_error(error_messages[:max_val]), status:400 if negative_max 
      return render json: Api::V1::ErrorSerializer.val_error(error_messages[:min_val]), status:400 if negative_min 
      return render json: Api::V1::ErrorSerializer.format_error(error_messages[:missing_param]), status: 400 if no_params 
      return render json: Api::V1::ErrorSerializer.format_error(error_messages[:empty_param]), status: 400 if empty_params 
      return render json: Api::V1::ErrorSerializer.format_error(error_messages[:name_price]), status: 400 if name_and_price
      return render json: Api::V1::ErrorSerializer.format_error(error_messages[:max_less_than_min]), status: 400 if max_less_than_min 
    end

    def search_one_item
      return Item.search_one_by_name(params[:name]) if search_name
      return Item.search_one_by_min(params[:min_price]) if search_min
      return Item.search_one_by_max(params[:max_price]) if search_max
      return Item.search_one_by_max_min(params[:min_price], params[:max_price]) if search_max_min
    end

    def search_items
      return Item.search_all_by_name(params[:name]) if search_name
      return Item.search_all_by_min(params[:min_price]) if search_min
      return Item.search_all_by_max(params[:max_price]) if search_max
      return Item.search_all_by_max_min(params[:min_price], params[:max_price]) if search_max_min
    end

    def search_name 
      params[:name] && params[:name] != ''
    end

    def search_max 
      params[:max_price] && params[:max_price] != '' && !params[:min_price]
    end

    def search_min
      params[:min_price] && params[:min_price] != '' && !params[:max_price]
    end

    def search_max_min
      params[:max_price] && params[:min_price] && params[:max_price] > params[:min_price]
    end

    def negative_max
      item_params[:max_price].to_i < 0
    end

    def negative_min 
      item_params[:min_price].to_i < 0
    end

    def no_params
       item_params == {}
    end

    def empty_params
      item_params.values.first ==''
    end

    def name_and_price
      item_params[:name] && item_params[:max_price] || 
      item_params[:name] && item_params[:min_price] ||
      item_params[:name] && item_params[:min_price] && item_params[:name]
    end

    def max_less_than_min
      params[:max_price] && params[:min_price] && item_params[:max_price].to_i < item_params[:min_price].to_i
    end

    def error_messages
      messages = Hash.new 
      messages[:max_val]='max_price cannot be negative'
      messages[:min_val]='min_price cannot be negative'
      messages[:missing_param]='Parameter cannot be missing'
      messages[:empty_param] = 'Parameter cannot be empty'
      messages[:name_price]='Cannot send both name and price'
      messages[:max_less_than_min]='max_price cannot be less than min_price'
      messages
    end
end