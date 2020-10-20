FactoryBot.define do
  factory :question do
    title { 'super or super()?' }
    body { 'What is the difference between calling super and calling super()?' }

    trait :invalid do
      title { nil }
    end
  end
end
