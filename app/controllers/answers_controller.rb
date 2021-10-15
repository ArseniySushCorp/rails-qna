class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[show update destroy set_best]

  def show; end

  def create
    @answer = @question.answers.create(answer_params.merge(author: current_user))
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

    redirect_to question_path(@answer.question)
  end

  def set_best
    if current_user.author_of?(@answer.question)
      @answer.assign_as_best
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
    params.require(:answer).permit(:body)
  end
end
