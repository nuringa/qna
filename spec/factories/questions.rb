FactoryBot.define do
  sequence :title do |n|
    "Question #{n}"
  end

  factory :question do
    title { 'Simple question'}
    body { 'Body of the question' }

    trait :invalid do
      title { nil }
    end

    trait :for_list do
      title
      body { 'Body of the question' }
    end
  end
end
