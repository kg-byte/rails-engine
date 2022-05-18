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

  it 'finds all items by partial name match' do 
    create(:item, name: 'Gold Ring Op')
    create(:item, name: 'Turing')
    create(:item, name: 'Platinum Ring')

    get "/api/v1/items/find_all?name=ring"

    items_found = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    expect(items_found.count).to eq(3)
    expect(items_found[0][:attributes][:name]).to eq('Gold Ring Op')
  end

  it 'finds all items by min_price search' do 
    create(:item, name: 'Turing',  unit_price: '30')
    create(:item, name: 'Gold Ring Op', unit_price: '80')
    create(:item, name: 'Platinum Ring', unit_price: '20')

    get "/api/v1/items/find_all?min_price=25"

    items_found = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    expect(items_found.count).to eq(2)
    expect(items_found[1][:attributes][:name]).to eq('Gold Ring Op')
  end

  it 'finds all items by min_price search' do 
    create(:item, name: 'Turing',  unit_price: '30')
    create(:item, name: 'Gold Ring Op', unit_price: '80')
    create(:item, name: 'Platinum Ring', unit_price: '20')

    get "/api/v1/items/find_all?max_price=50"

    items_found = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    expect(items_found.count).to eq(2)
    expect(items_found[0][:attributes][:name]).to eq('Turing')
  end

  it 'finds all items by min and max_price search' do 
    create(:item, name: 'Turing',  unit_price: '30')
    create(:item, name: 'Gold Ring Op', unit_price: '80')
    create(:item, name: 'Platinum Ring', unit_price: '20')

    get "/api/v1/items/find_all?min_price=10&max_price=50"

    items_found = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    expect(items_found.count).to eq(2)
    expect(items_found[0][:attributes][:name]).to eq('Turing')
  end

  it 'returns empty array when no merchant(alphabetical)(find_all) by partial match' do 
    create(:item, name: 'Gold Ring Op')
    create(:item, name: 'Turing')
    create(:item, name: 'Platinum Ring')

    get "/api/v1/items/find_all?name=ringggg"

    items_found = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful    
    expect(items_found).to eq([])
  end

  it 'finds and sends first item(alphabetical) by partial name match' do 
    create(:item, name: 'Gold Ring Op')
    create(:item, name: 'Turing')
    create(:item, name: 'Platinum Ring')

    get "/api/v1/items/find?name=ring"
    item_found = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    expect(item_found[:attributes][:name]).to eq('Gold Ring Op')
  end

  it 'returns error when no item(alphabetical)(find) by partial name match' do 
    create(:item, name: 'Gold Ring Op')
    create(:item, name: 'Turing')
    create(:item, name: 'Platinum Ring')

    get "/api/v1/items/find?name=ringgg"
    item_found = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    expect(item_found[:error]).to eq('Item not found')
  end

  it 'finds and sends first item(alphabetical) by min price search' do 
    create(:item, name: 'Gold Ring Op', unit_price: '20')
    create(:item, name: 'Turing',  unit_price: '50')
    create(:item, name: 'Platinum Ring', unit_price: '50')

    get "/api/v1/items/find?min_price=40"
    item_found = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    expect(item_found[:attributes][:name]).to eq('Platinum Ring')
  end

  it 'finds and sends first item(alphabetical) by max price search' do 
    create(:item, name: 'Turing',  unit_price: '20')
    create(:item, name: 'Gold Ring Op', unit_price: '20')
    create(:item, name: 'Platinum Ring', unit_price: '50')

    get "/api/v1/items/find?max_price=40"
    item_found = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    expect(item_found[:attributes][:name]).to eq('Gold Ring Op')
  end

  it 'finds and sends first item(alphabetical) by max and min price search' do 
    create(:item, name: 'Turing',  unit_price: '30')
    create(:item, name: 'Gold Ring Op', unit_price: '80')
    create(:item, name: 'Platinum Ring', unit_price: '20')

    get "/api/v1/items/find?max_price=40&min_price=10"
    item_found = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    expect(item_found[:attributes][:name]).to eq('Platinum Ring')
  end

end

  describe 'edge cases' do 
    it 'handles edge case with no params when finding one item' do 
      get "/api/v1/items/find"
      item_found = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response.status).to eq(400)
      expect(item_found[:error]).to eq('Parameter cannot be missing')
    end

    it 'handles edge case with empty params when finding one merchant' do 
    
      get "/api/v1/items/find?name="

      item_found = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response.status).to eq(400)
      expect(item_found[:error]).to eq('Parameter cannot be empty')
    end
    it 'handles edge case with no params when finding items' do 

      get "/api/v1/items/find_all"
      item_found = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response.status).to eq(400)
      expect(item_found[:error]).to eq('Parameter cannot be missing')
    end

    it 'handles edge case with empty params when finding items' do 

      get "/api/v1/items/find_all?name="

      item_found = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response.status).to eq(400)
      expect(item_found[:error]).to eq('Parameter cannot be empty')
    end

    it 'handles edge case when max_price is less than min price' do 

      get "/api/v1/items/find?max_price=50&min_price=100"

      item_found = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response.status).to eq(400)
      expect(item_found[:error]).to eq('max_price cannot be less than min_price')
  end

    it 'handles edge case where max_price cannot be negative' do 
      get "/api/v1/items/find?max_price=-50"
      item_found = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(400)
      expect(item_found[:error]).to eq('max_price cannot be negative')

    end
end