class Api::V2::MerchantsController < ApplicationController
  include ApiKeyAuthenticatable, ParamsHelper
  before_action :authenticate_with_api_key!
  def index
    merchants = Merchant.all.paginate(page: page_num, per_page: num_per_page)
  	render json: Api::V1::MerchantSerializer.new(merchants)
  end

  def show
  	render json: Api::V1::MerchantSerializer.new(Merchant.find(params[:id]))
  end

end