class Api::V1::MerchantsController < ApplicationController
  def index
    params[:page] = 1 unless params[:page]
    params[:per_page] = 20 unless params[:per_page]
    merchants = Merchant.all.paginate(page: params[:page], per_page: params[:per_page])
  	render json: Api::V1::MerchantSerializer.new(merchants)
  end

  def show
  	render json: Api::V1::MerchantSerializer.new(Merchant.find(params[:id]))
  end
end