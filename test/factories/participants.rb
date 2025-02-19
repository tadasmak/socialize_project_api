FactoryBot.define do
  factory :participant do
    association :activity
    association :user
  end
end
