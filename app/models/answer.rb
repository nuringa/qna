class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def select_best!
    transaction do
      self.class.where(question_id: self.question_id).update_all(best: false)
      update(best: true)
    end
  end
end
