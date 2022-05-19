class Api::V2::ItemMerchantController < ApplicationController
  include ApiKeyAuthenticatable
  before_action :set_item, :authenticate_with_api_key!
  
  def show
  	render json: Api::V1::MerchantSerializer.new(@item.merchant)
  end

private
  def set_item
    @item = Item.find(params[:id])
  end
end