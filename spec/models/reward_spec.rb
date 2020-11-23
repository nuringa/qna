require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to(:question).optional }
  it { is_expected.to belong_to(:user).optional }

  it { should validate_presence_of :title }
  it { should validate_presence_of :file }

  it 'has one attached image' do
    expect(Reward.new.file).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
