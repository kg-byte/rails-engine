class Api::V1::MerchantsTopsoldController < ApplicationController
  include ParamsHelper
  def index
    render json: MerchantTopsoldSerializer.new(top_sold(params[:quantity].to_i))
  end

private
  def top_sold(quantity)
    quantity = 100 if quantity>100
    Merchant.top_merchants_by_items_sold(quantity)
  end
end