class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  expose :question, parent: :current_user

  def index
    @questions = Question.all
  end

  def create
    if question.save
      redirect_to question_path(question), notice: 'Question was successfully created'
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
