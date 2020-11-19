require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:author) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for(:links).allow_destroy(true) }

  it { should validate_presence_of :title}
  it { should validate_presence_of :body}

  it 'can have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
