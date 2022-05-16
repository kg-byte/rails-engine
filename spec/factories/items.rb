FactoryBot.define do
  factory :item do
    association :merchant
    name { Faker::Commerce.product_name}
    description { Faker::Commerce.material }
    unit_price { Faker::Number.within(range: 1..100_000)}
  end
end