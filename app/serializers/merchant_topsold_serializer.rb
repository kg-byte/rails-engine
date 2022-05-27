class MerchantTopsoldSerializer 
  include JSONAPI::Serializer
  set_type :items_sold
  attributes :name

  attribute :count do |object|
    object.items_sold
  end
end