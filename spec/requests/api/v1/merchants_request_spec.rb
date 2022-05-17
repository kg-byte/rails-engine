require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)
    get '/api/v1/merchants'
    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(3)
    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq('merchant')

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "sends a specific merchants" do
    merchant = create(:merchant)
    get "/api/v1/merchants/#{merchant.id}"
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to eq('merchant')

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  it 'sends all items belonging to a merchant' do 
    merchant = create(:merchant)
    items = create_list(:item,3, merchant_id: merchant.id)
    get "/api/v1/merchants/#{merchant.id}/items"
    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(items.count).to eq(3)
    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to eq('item')

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)


      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  it 'finds and sends first merchant(alphabetical) by partial match' do 
    merchant1 = Merchant.create(name: 'Gold Ring Op')
    merchant2 = Merchant.create(name: 'Turing')
    merchant2 = Merchant.create(name: 'Platinum Ring')

    get "/api/v1/merchants/find?name=ring"
    merchant_found = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    expect(merchant_found[:attributes][:name]).to eq('Gold Ring Op')
  end

  it 'returns error when no merchant(alphabetical)(find) by partial match' do 
    merchant1 = Merchant.create(name: 'Gold Ring Op')
    merchant2 = Merchant.create(name: 'Turing')
    merchant2 = Merchant.create(name: 'Platinum Ring')

    get "/api/v1/merchants/find?name=ringgg"
    merchant_found = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    expect(merchant_found[:error]).to eq('Merchant not found')
  end

  it 'finds and sends all merchant by partial match' do 
    merchant1 = Merchant.create(name: 'Gold Ring Op')
    merchant2 = Merchant.create(name: 'Turing')
    merchant2 = Merchant.create(name: 'Platinum Ring')

    get "/api/v1/merchants/find_all?name=ring"
    merchants_found = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    expect(merchants_found.count).to eq(3)
    expect(merchants_found[0][:attributes][:name]).to eq('Gold Ring Op')
  end


  it 'returns empty array when no merchant(alphabetical)(find_all) by partial match' do 
    merchant1 = Merchant.create(name: 'Gold Ring Op')
    merchant2 = Merchant.create(name: 'Turing')
    merchant2 = Merchant.create(name: 'Platinum Ring')

    get "/api/v1/merchants/find_all?name=ringgg"
    merchant_found = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    expect(merchant_found).to eq([])
  end

  describe 'edge cases' do 
    it 'handles edge case with no params when finding one merchant' do 
      get "/api/v1/merchants/find"
      merchant_found = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response.status).to eq(400)
      expect(merchant_found[:error]).to eq('Parameter cannot be missing')
    end

    it 'handles edge case with empty params when finding one merchant' do 
      get "/api/v1/merchants/find?name="

      merchant_found = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response.status).to eq(400)
      expect(merchant_found[:error]).to eq('Parameter cannot be empty')
    end
    it 'handles edge case with no params when finding merchants' do 
      get "/api/v1/merchants/find_all"
      merchant_found = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response.status).to eq(400)
      expect(merchant_found[:error]).to eq('Parameter cannot be missing')
    end

    it 'handles edge case with empty params when finding merchants' do 
      get "/api/v1/merchants/find_all?name="

      merchant_found = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response.status).to eq(400)
      expect(merchant_found[:error]).to eq('Parameter cannot be empty')
    end
  end
end