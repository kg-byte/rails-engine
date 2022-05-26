class Api::V1::SearchMerchantsController < ApplicationController
  include ParamsHelper, EdgeCasesHelper
  def index
    edge_case_resposne if edge_cases_conditions
  	render json: Api::V1::MerchantSerializer.new(Merchant.search_all_by_name(merchant_params[:name])) if !edge_cases_conditions
    
  end

  def show
    if edge_cases_conditions
      edge_case_resposne
    else
      merchant = Merchant.search_one_by_name(merchant_params[:name])
      render json: Api::V1::MerchantSerializer.new(merchant), status: :ok if merchant
      render json: {data: {error: 'Merchant not found'}} if !merchant
    end 
  end

end