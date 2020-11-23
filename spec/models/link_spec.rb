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

  describe '#gist?' do
    let(:link_to_gist) { create(:link, url: 'https://gist.github.com/nuringa/6afe26f1d6c0236787a6ee9d002378af') }
    let(:link) { create(:link) }

    describe 'gist instead link' do
      it { expect(link_to_gist).to be_gist }
    end

    describe 'link' do
      it { expect(link).to_not be_gist }
    end
  end
end
