FactoryBot.define do
  factory :answer do
    body { 'Super() invokes the parent method without any arguments, as presumably expected.' }
    question
  end
end
