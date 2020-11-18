class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url,
            presence: true,
            length: { maximum: 245 },
            format: { with: URI.regexp(%w[http https]), message: 'format is wrong' }

  def gist?
    URI.parse(url).host.include?('gist')
  end
end
