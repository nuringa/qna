class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def select_best!
    former_best = question.answers.find_by(best: true)

    transaction do
      former_best.update!(best: false) if former_best.present?
      update!(best: true)
    end
  end
end
