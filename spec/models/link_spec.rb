require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should validate_length_of(:url).is_at_most(245) }

  it do
    should allow_values('https://foo.com', 'http://foo.com').for(:url)
  end

  it do
    should_not allow_values('foo', 'foo.com')
      .for(:url)
      .with_message('format is wrong')
  end
end
