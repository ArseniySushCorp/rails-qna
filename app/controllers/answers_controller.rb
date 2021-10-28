class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[show]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[show update destroy set_best]

  after_action :publish_answer, only: %i[create]

  def show; end

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      head :forbidden
    end
  end

  def set_best
    if current_user.author_of?(@answer.question)
      @answer.assign_as_best
      helpers.grant_reward(@answer.user)
    else
      head :forbidden
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      'answers',
      {
        answer: @answer,
        current_user: current_user,
        create_comment_token: form_authenticity_token
      }.to_json
    )
  end
end
