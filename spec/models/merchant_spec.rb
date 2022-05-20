require "rails_helper"

RSpec.describe Merchant, type: :model do
  let!(:merchant1) {Merchant.create(name: 'Gold Ring Op')}
  let!(:merchant2) {Merchant.create(name: 'Turing')}
  let!(:merchant3) {Merchant.create(name: 'Platinum Ring')}
 
  it 'searchses all merchants by name' do 
    expect(Merchant.search_all_by_name('ring')).to eq([merchant1, merchant2, merchant3])
  end

  it 'searches one merchant by name(alphabetical)' do 
    expect(Merchant.search_one_by_name('ring')).to eq(merchant1)
  end

  it 'checks whether id exists' do 
    expect(Merchant.id_exist?(merchant3.id)).to be true
    expect(Merchant.id_exist?(0)).to be false

  end
end