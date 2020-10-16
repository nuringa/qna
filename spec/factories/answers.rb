FactoryBot.define do
  factory :answer do
    body { 'Super() invokes the parent method without any arguments, as presumably expected.' }
    question

    trait :invalid do
      body { nil }
    end
  end
end
