class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      return admin_abilities if user.admin?

      user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]
    can :manage, [Question, Answer, Comment], user_id: user.id
    can :vote, [Question, Answer]
    can :cancel_vote, Vote, user_id: user.id
    can :nominate, Answer, question: { user_id: user.id }
    can :subscribe, QuestionSubscription
    can :unsubscribe, QuestionSubscription

    cannot :vote, [Question, Answer], user_id: user.id
  end

  def admin_abilities
    user_abilities

    can :manage, :all
  end
end
