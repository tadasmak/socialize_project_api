FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.username }
    password { Faker::Internet.password }
    personality { rand(1..7) }
    birth_date { Faker::Date.birthday(min_age: 21, max_age: 23) }
  end
end
