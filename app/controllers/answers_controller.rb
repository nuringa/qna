class AnswersController < ApplicationController
  before_action :authenticate_user!

  before_action :load_question, only: %i[create]
  before_action :load_answer, only: %i[update destroy best]

  after_action :publish_answer, only: %i[create]

  include Voted

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    else
      flash[:danger] = 'Action not allowed'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:danger] = 'Your answer was deleted.'
      render :destroy
    else
      flash[:danger] = 'Action not allowed'
    end
  end

  def best
    if current_user.author_of?(@answer.question)
      @answer.select_best!
    else
      flash[:danger] = 'Action not allowed'
    end
  end

  private

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                   links_attributes: [:id, :name, :url, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast "question-#{@question.id}",
                                 answer: @answer,
                                 rating: @answer.rating,
                                 files: files_for_broadcast,
                                 links: @answer.links
  end
  
  def files_for_broadcast
    @answer.files&.map { |f| { filename: f.filename.to_s, url: url_for(f), id: f.id } }
  end
end
