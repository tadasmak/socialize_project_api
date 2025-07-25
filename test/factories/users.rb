FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:username) { |n| "username#{n}" }
    password { "Password123!" }
    sequence(:personality) { |n| (n % 7) + 1 }
    birth_date { Date.new(2000, 1, 1) }
  end
end
