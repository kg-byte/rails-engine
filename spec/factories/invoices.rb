FactoryBot.define do
  factory :invoice do
    association :merchant
    status {[0, 1, 2].sample}
    id { Faker::Number.unique.within(range: 1..100_000)}
  end
end