class Ability
	include CanCan::Ability

	attr_reader :user

	def initialize(user)
		@user = user

		if user
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

		cannot :vote, [Question, Answer], user_id: user.id
	end
end
