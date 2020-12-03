class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  after_action :publish_question, only: %i[create]

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
    @answers = @question.answers.sort_by_best
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question was deleted.'
    else
      flash[:notice] = 'Action not allowed'
      render :show
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     reward_attributes: [:title, :file])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions', question: @question, author_email: @question.author.email)
  end
end
