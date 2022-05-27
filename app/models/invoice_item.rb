class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  enum status: {"packaged" => 0, "pending" => 1, "shipped" => 2}

  def self.total_revenue_during(start_date, end_date)
    start_d = Time.zone.parse('2012-03-27')
    end_d = Time.zone.parse('2012-03-29')
    invoice_items = InvoiceItem.where(created_at: start_d..end_d).sum('quantity*unit_price')
  end

end
