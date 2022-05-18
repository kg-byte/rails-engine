class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all.paginate(page: page_num, per_page: num_per_page)
  	render json: Api::V1::MerchantSerializer.new(merchants)
  end

  def show
  	render json: Api::V1::MerchantSerializer.new(Merchant.find(params[:id]))
  end

  private
  def page_num
    params[:page]? params[:page] : 1
  end

  def num_per_page
    params[:per_page]? params[:per_page] : 20
  end
end