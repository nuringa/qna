FactoryBot.define do
  factory :comment do
    body { "Comment Text" }
    author

    trait :invalid do
      body { nil }
    end
  end
end
