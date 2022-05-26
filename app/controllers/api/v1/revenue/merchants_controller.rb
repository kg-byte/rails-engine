class Api::V1::Revenue::MerchantsController < ApplicationController
  include ParamsHelper
  def index
    edge_case_resposne if edge_cases_conditions
    render json: Api::V1::RevenueMerchantSerializer.new(merchants)
  end

private
  def top_merchants(quantity)
    Merchant.top_merchants_by_revenue(quantity.to_i)
  end
end