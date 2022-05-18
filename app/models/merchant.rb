class Merchant < ApplicationRecord
  has_many :items

  def self.search_all_by_name(name)
    Merchant.where("lower(name) like ?", "%#{name.downcase}%")
  end

  def self.search_one_by_name(name)
    search_all_by_name(name).order(:name).first
  end

  def self.id_exist?(id)
    pluck(:id).include?(id)
  end
end