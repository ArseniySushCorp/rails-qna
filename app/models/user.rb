class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :question_subscription
  has_many :subscribed_questions, through: :question_subscription, source: :question, dependent: :destroy
end
