module AnswersHelper
  def grant_reward(user)
    user.rewards << @answer.question.reward if @answer.question.reward
  end
end
