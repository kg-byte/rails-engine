class Item < ApplicationRecord
  belongs_to :merchant

  def self.search_one_by_name(name)
    search_all_by_name(name).order(:name).first
  end

  def self.search_one_by_max(max_price)
    search_all_by_max(max_price).order(:name).first
  end

  def self.search_one_by_min(min_price)
    search_all_by_min(min_price).order(:name).first
  end

  def self.search_one_by_max_min(min_price, max_price)
   search_all_by_max_min(min_price, max_price).order(:name).first
  end

  def self.search_all_by_name(name)
    Item.where("lower(name) like ?", "%#{name.downcase}%")
  end

  def self.search_all_by_max(max_price)
    Item.where("unit_price < #{max_price.to_i}")
  end

  def self.search_all_by_min(min_price)
    Item.where("unit_price > #{min_price.to_i}")
  end

  def self.search_all_by_max_min(min_price, max_price)
    Item.where(unit_price: min_price.to_i..max_price.to_i)
  end
end
