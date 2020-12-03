class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comment-question-#{params['id']}"
  end
end
