class Reward < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question, optional: true

  has_one_attached :file

  validates :title, :file, presence: true
end
