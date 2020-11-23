FactoryBot.define do
  factory :vote do
    user
    association :votable, factory: :question

    rate { 0 }
  end
end
