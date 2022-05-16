class Api::V1::MerchantSerializer
  include JSONAPI::Serializer 
  attributes :id, :name 
  has_many :items
end