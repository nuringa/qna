# frozen_string_literal: true
module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    vote!(user, 1)
  end

  def vote_down(user)
    vote!(user, -1)
  end

  def cancel_vote(user)
    vote!(user, 0)
  end

  def rating
    votes.sum(:rate)
  end

  private

  def vote!(user, rate)
    return if user.author_of?(self)

    transaction do
      vote = votes.find_or_initialize_by(user: user)
      vote.update!(user: user, rate: rate)
    end
  end
end
