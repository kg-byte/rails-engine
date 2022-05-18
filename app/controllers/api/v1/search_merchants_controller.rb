class Api::V1::SearchMerchantsController < ApplicationController
  def index
    if edge_cases_conditions
      edge_case_resposne
    elsif name_search
  	  render json: Api::V1::MerchantSerializer.new(Merchant.search_all_by_name(params[:name])) 
    end
  end

  def show
    if edge_cases_conditions
      edge_case_resposne
    elsif name_search
      merchant = Merchant.search_one_by_name(params[:name])
      render json: Api::V1::MerchantSerializer.new(merchant), status: :ok if merchant
      render json: {data: {error: 'Merchant not found'}} if !merchant
    end 
  end

  private 
    def name_search
      params[:name] && params[:name] != ''
    end

    def no_params
      !params[:name]
    end

    def empty_params
       params[:name] ==''
    end

    def edge_cases_conditions
      no_params || empty_params
    end

    def edge_case_resposne
      return render json: Api::V1::ErrorSerializer.format_error(error_messages[:missing_param]), status: 400 if no_params 
      return render json: Api::V1::ErrorSerializer.format_error(error_messages[:empty_param]), status: 400 if empty_params 
    end

    def error_messages
      messages = Hash.new 
      messages[:missing_param]='Parameter cannot be missing'
      messages[:empty_param] = 'Parameter cannot be empty'
      messages
    end
end