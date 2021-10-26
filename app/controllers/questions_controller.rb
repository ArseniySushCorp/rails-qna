class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show update destroy]

  after_action :publish_question, only: %i[create]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.build
    @question.build_reward
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: t('user_actions.successfully_created', resource: @question.class)
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
      flash[:notice] = t('user_actions.successfully_deleted', resource: @question.class)
    else
      flash[:notice] = t('user_actions.delete_rejected', resource: @question.class.to_s.downcase)
    end

    redirect_to questions_path
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], reward_attributes: %i[title image], links_attributes: %i[name url _destroy])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      {
        question: @question,
        current_user: current_user,
        create_comment_token: form_authenticity_token
      }.to_json
    )
  end
end
