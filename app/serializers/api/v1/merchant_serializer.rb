class Api::V1::MerchantSerializer
  include JSONAPI::Serializer 
  attributes :id, :name, :created_at, :updated_at
end