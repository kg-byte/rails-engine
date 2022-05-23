class Api::V2::SearchItemsController < ApplicationController
  before_action :authenticate_with_api_key!
  include ParamsHelper, EdgeCasesHelper, ApiKeyAuthenticatable
  def index
    edge_case_resposne if edge_cases_conditions
	  render json: Api::V1::ItemSerializer.new(search_items) if !edge_cases_conditions
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
    def search_one_item
      return Item.search_one_by_name(params[:name]) if search_name
      return Item.search_one_by_max_min(min_price: params[:min_price], max_price: params[:max_price]) if search_price
    end

    def search_items
      return Item.search_all_by_name(params[:name]) if search_name
      return Item.search_all_by_max_min(min_price: params[:min_price], max_price: params[:max_price]) if search_price
    end

end