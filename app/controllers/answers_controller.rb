class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]

  before_action :load_question, only: %i[create]
  before_action :load_answer, only: %i[update destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
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

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
