require "rails_helper"

RSpec.describe Item, type: :model do
  let!(:item1) {create(:item, name: 'Gold Ring Op', unit_price: '50')}
  let!(:item2) {create(:item, name: 'Turing',  unit_price: '20')}
  let!(:item3) {create(:item, name: 'Platinum Ring', unit_price: '20')}

  it 'search all by name' do 
    expect(Item.search_all_by_name('ring')).to eq([item1, item2, item3])
  end

  it 'search one by max price' do 
    expect(Item.search_one_by_max_min(nil,'60')).to eq(item1)
  end

  it 'search one by min price' do 
    expect(Item.search_one_by_max_min('10',nil)).to eq(item1)
  end

  it 'search one by max and min price' do 
    expect(Item.search_one_by_max_min('20', '60')).to eq(item1)
  end

  it 'search all by name' do 
    expect(Item.search_all_by_name('ring')).to eq([item1, item2, item3])
  end

  it 'search all by max price' do 
    expect(Item.search_all_by_max_min(nil,'40')).to eq([item2, item3])
  end

  it 'search all by min price' do 
    expect(Item.search_all_by_max_min('10', nil)).to eq([item1, item2, item3])
  end

  it 'search all by max and min' do 
    expect(Item.search_all_by_max_min('10', '40')).to eq([item2, item3])

  end
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