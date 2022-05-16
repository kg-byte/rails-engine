class Api::V1::ItemMerchantController < ApplicationController
before_action :set_item
  def show
  	render json: Api::V1::MerchantSerializer.new(@item.merchant)
  end

private
  def set_item
    @item = Item.find(params[:id])
  end
end