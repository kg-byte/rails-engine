class Api::V1::MerchantsController < ApplicationController
  def index
  	render json: Api::V1::MerchantSerializer.new(Merchant.all)
  end
end