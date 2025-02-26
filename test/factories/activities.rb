FactoryBot.define do
  factory :activity do
    title { Faker::Lorem.paragraph_by_chars(number: rand(8..100)).gsub(/[<>{}\[\]|\\^~]/, "") }
    description { Faker::Lorem.paragraph_by_chars(number: 256).gsub(/[<>{}\[\]|\\^~]/, "") }
    location { Faker::Address.city[4..100].gsub(/[<>{}\[\]|\\^~]/, "") }
    start_time { Faker::Time.between(from: 1.hour.from_now, to: 1.month.from_now) }
    max_participants { rand(2..8) }

    association :user
  end
end
