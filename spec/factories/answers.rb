FactoryBot.define do
  sequence :body do |n|
    "Body of the answer #{n}"
  end

  factory :answer do
    body { 'Test answer' }
    question

    trait :invalid do
      body { nil }
    end

    trait :for_list do
      body
    end
  end
end
