FactoryBot.define do
  factory :activity do
    title { Faker::Lorem.paragraph_by_chars(number: rand(8..100)).gsub(/[<>{}\[\]|\\^~]/, "") }
    description { Faker::Lorem.paragraph_by_chars(number: 256).gsub(/[<>{}\[\]|\\^~]/, "") }

    location do
      city = Faker::Address.city
      while city.length < 4 || city.length > 100
        city = Faker::Address.city
      end
      city.gsub(/[<>{}\[\]|\\^~]/, "")
    end

    start_time { Faker::Time.between(from: 1.hour.from_now, to: 1.week.from_now) }
    max_participants { rand(2..8) }

    minimum_age { 20 }
    maximum_age { minimum_age + rand(4..8) }

    association :user
  end
end
