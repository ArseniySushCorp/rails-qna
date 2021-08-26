class AnswersController < ApplicationController
  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer

  def create
    @answer = question.answers.build(answer_params)

    if @answer.save
      redirect_to answer_path(@answer)
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:correct, :body)
  end
end
