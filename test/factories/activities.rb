FactoryBot.define do
  factory :activity do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    location { Faker::Address.city }
    start_time { Faker::Time.forward(days: 5, period: :evening) }
    max_participants { rand(2..8) }

    association :user
  end
end
