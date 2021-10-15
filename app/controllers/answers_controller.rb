class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[show destroy]

  def show; end

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))

    if @answer.save
      redirect_to question_path(@answer.question), notice: t('user_actions.successfully_created', resource: @answer.class)
    else
      redirect_to question_path(@answer.question), notice: @answer.errors.full_messages.to_sentence
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = t('user_actions.successfully_deleted', resource: @answer.class)
    else
      flash[:notice] = t('user_actions.delete_rejected', resource: @answer.class.to_s.downcase)
    end

    redirect_to question_path(@answer.question)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
