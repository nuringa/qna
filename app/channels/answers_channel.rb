class AnswersChannel < ApplicationCable::Channel
  def follow(params)
    stream_from "question-#{params['id']}"
  end
end
