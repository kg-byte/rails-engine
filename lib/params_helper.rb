module ParamsHelper 

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def search_name
    params[:name] && params[:name] != ''
  end

  def page_num
    params[:page]? params[:page] : 1
  end

  def num_per_page
    params[:per_page]? params[:per_page] : 20
  end

  def merchant_no_params
	  !params[:name]
  end

  def merchant_empty_params
     params[:name] ==''
  end

  def item_search_params
    params.permit(:name, :max_price, :min_price)
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
    item_search_params[:max_price].to_i < 0
  end

  def negative_min 
    item_search_params[:min_price].to_i < 0
  end

  def no_params
     item_search_params == {}
  end

  def empty_params
    item_search_params.values.first ==''
  end

  def name_and_price
    item_search_params[:name] && item_search_params[:max_price] || 
    item_search_params[:name] && item_search_params[:min_price] ||
    item_search_params[:name] && item_search_params[:min_price] && item_search_params[:name]
  end

  def max_less_than_min
    params[:max_price] && params[:min_price] && item_search_params[:max_price].to_i < item_search_params[:min_price].to_i
  end

end
