class Api::V1::MerchantsController < ApplicationController
  def index
  	render json: Api::V1::MerchantSerializer.new(Merchant.all)
  end

  def show
  	render json: Api::V1::MerchantSerializer.new(Merchant.find(params[:id]))
  end
end