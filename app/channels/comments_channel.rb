class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question-#{params['id']}"
  end
end
