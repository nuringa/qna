FactoryBot.define do
  sequence :reward_title do |n|
    "Reward#{n}"
  end

  factory :reward do
    title { generate(:reward_title) }
    file { Rack::Test::UploadedFile.new('spec/support/files/image.png', 'image/png') }
  end
end
