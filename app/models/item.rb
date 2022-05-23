class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.search_one_by_name(name)
    search_all_by_name(name).order(:name).first
  end

  def self.search_one_by_max_min(min_price: "0", max_price: Float::MAX)
   search_all_by_max_min(min_price: min_price, max_price: max_price).order(:name).first
  end

  def self.search_all_by_name(name)
    where("lower(name) like ?", "%#{name.downcase}%")
  end

  def self.search_all_by_max_min(min_price:"0", max_price:Float::MAX)
    min_price = '0' unless min_price
    max_price = Float::MAX unless max_price
    return where(unit_price: min_price.to_i..max_price.to_i) if max_price.class == String 
    return where(unit_price: min_price.to_i..max_price) if max_price.class != String
  end

  def destroy_single_invoices
    single_invoices = Invoice.joins(:items).group(:id).having("count(item_id) = 1")
    Invoice.where(id: single_invoices.pluck(:id)).destroy_all
  end


end
  