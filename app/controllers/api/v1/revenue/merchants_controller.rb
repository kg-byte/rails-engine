class Api::V1::Revenue::MerchantsController < ApplicationController
  include ParamsHelper
  def index
    render json: Api::V1::RevenueMerchantSerializer.new(top_merchants(params[:quantity].to_i))
  end

private
  def top_merchants(quantity)
    quantity = 100 if quantity>100
    Merchant.top_merchants_by_revenue(quantity)
  end
end