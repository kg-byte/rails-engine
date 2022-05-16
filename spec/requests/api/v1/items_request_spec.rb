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

    it 'creates a new item' do 
      merchant = create(:merchant)
      item_params = ({
                        "name": "value1",
                        "description": "value2",
                        "unit_price": 100.99,
                        "merchant_id": merchant.id
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
end