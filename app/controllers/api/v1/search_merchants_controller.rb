class Api::V1::SearchMerchantsController < ApplicationController
  def index
    if params[:name] && params[:name] != ''
      merchants = Merchant.where("lower(name) like ?", "%#{params[:name].downcase}%")
  	  render json: Api::V1::MerchantSerializer.new(merchants)
    end
    render json: {data: {error: 'Parameter cannot be missing'}}, status: 400 if !params[:name]
    render json: {data: {error: 'Parameter cannot be empty'}}, status: 400 if params[:name] ==''
  end

  def show
    if params[:name] && params[:name] != ''
      merchant = Merchant.where("lower(name) like ?", "%#{params[:name].downcase}%").order(:name).first
      if merchant 
          render json: Api::V1::MerchantSerializer.new(merchant), status: :ok
      else 
        render json: {data: {error: 'Merchant not found'}}
      end
    end
      render json: {data: {error: 'Parameter cannot be missing'}}, status: 400 if !params[:name]
      render json: {data: {error: 'Parameter cannot be empty'}}, status: 400 if params[:name] ==''
  end
  

end