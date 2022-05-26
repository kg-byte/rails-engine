class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :invoices 
  has_many :invoices 
  has_many :customers, through: :invoices 
  has_many :transactions, through: :invoices


  def self.search_all_by_name(name)
    where("lower(name) like ?", "%#{name.downcase}%")
  end

  def self.search_one_by_name(name)
    search_all_by_name(name).order(:name).first
  end

  def self.id_exist?(id)
    pluck(:id).include?(id)
  end

  def self.top_merchants_by_revenue(quantity)
     select('merchants.*, SUM(invoice_items.quantity*invoice_items.unit_price) AS revenue')
    .joins(invoices: [:invoice_items, :transactions])
    .group(:id)
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
    .order(revenue: :desc)
    .limit(quantity)
  end
end