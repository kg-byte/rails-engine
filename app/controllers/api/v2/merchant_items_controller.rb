class Api::V2::MerchantItemsController < ApplicationController
include ApiKeyAuthenticatable
before_action :set_merchant, :authenticate_with_api_key!
  def index
  	render json: Api::V1::ItemSerializer.new(@merchant.items)
  end

private
  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end