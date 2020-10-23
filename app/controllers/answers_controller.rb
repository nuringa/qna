class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @answer.question, notice: 'Your answer successfully created.'
    else
      redirect_to @answer.question, notice: @answer.errors.full_messages.join(' ')
    end
  end

  def index; end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Your answer was deleted.'
    else
      flash[:notice] = 'Action not allowed'
      render 'questions/show'
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
