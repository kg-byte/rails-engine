class Api::V1::MerchantItemsController < ApplicationController

before_action :set_merchant
  def index
  	render json: Api::V1::ItemSerializer.new(@merchant.items)
  end

private
  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end