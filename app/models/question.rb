class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true
end
