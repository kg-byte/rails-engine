require 'rails_helper'

describe "Items API" do 

  it 'sends all items' do 
    merchant1 = create(:merchant)
    create_list(:item,3, merchant_id: merchant1.id)
    merchant2 = create(:merchant)
    create_list(:item,3, merchant_id: merchant2.id)

    get "/api/v1/items"

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(6)
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

  it 'sends one item' do 
    item = create(:item)

    get "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)[:data]

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

  it 'creates a new item and ignores extra attributes' do 
    merchant = create(:merchant)
    item_params = ({
                      "name": "value1",
                      "description": "value2",
                      "unit_price": 100.99,
                      "merchant_id": merchant.id,
                      "color": 'red'
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last 

    expect(response.status).to eq(201)
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'updates an existing item' do 
    item = create(:item)
    previous_name = Item.last.name 

    item_params = {name: 'new name'}
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)
    item = Item.find_by(id: item.id) 

    expect(response).to be_successful
    expect(item.name).to eq(item_params[:name])
    expect(item.name).to_not eq(previous_name)
  end

  it 'cannot update item with bad merchant_id' do 
    original_item = create(:item)
    new_merchant_id = original_item.merchant_id+1

    item_params = {merchant_id: new_merchant_id}
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{original_item.id}", headers: headers, params: JSON.generate(item: item_params)
    item = Item.find_by(id: original_item.id) 

    expect(item.merchant_id).to eq(original_item.merchant_id)
    expect(item.name).to_not eq(new_merchant_id)
    expect(response.status).to eq(404)
  end

  it 'destroys an item' do 
    item= create(:item)
    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'sends merchant info that an item belongs to' do 
    merchant = create(:merchant)
    item= create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful
   
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to eq('merchant')

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end
end