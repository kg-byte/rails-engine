require "rails_helper"

RSpec.describe Item, type: :model do

  it 'destroys invoices with only this item' do 
  	item1 = create(:item)
  	item2 = create(:item)
  	invoice1 = create(:invoice)
  	InvoiceItem.create(invoice:invoice1, item:item1)
  	invoice2 = create(:invoice)
  	InvoiceItem.create(invoice:invoice2, item:item1)
  	InvoiceItem.create(invoice:invoice2, item:item2)

  	item1.destroy_single_invoices
  	invoices=Invoice.all 	

  	expect(invoices.count).to eq(1)
  	expect(invoices[0].id).to eq(invoice2.id)
  end

end