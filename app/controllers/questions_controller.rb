class QuestionsController < ApplicationController
  expose :question

  def index
    @questions = Question.all
  end

  def create
    question = Question.create(question_params)

    if question.save
      redirect_to questions_path
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question_path(question)
    else
      render :edit
    end
  end

  def destroy
    question.destroy
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
