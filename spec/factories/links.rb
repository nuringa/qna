FactoryBot.define do
  factory :link do
    association :linkable, factory: :question
    name { "Link to google" }
    url { "http://www.google.com" }

    trait :for_answer do
      association :linkable, factory: :answer
    end
  end
end
