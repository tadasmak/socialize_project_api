FactoryBot.define do
  factory :activity do
    title { "Fun outdoor activity" }
    description { "This is a sample description for the activity that is long enough." }
    location { "Vilnius, Lithuania" }

    start_time { 1.week.from_now }
    sequence(:max_participants) { |n| (n % 7) + 2 }

    minimum_age { 20 }
    maximum_age { 28 }

    association :user
  end
end
