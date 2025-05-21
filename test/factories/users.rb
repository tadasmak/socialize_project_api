FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.username }
    password { Faker::Internet.password }
    personality { rand(1..7) }
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 100) }
  end
end
