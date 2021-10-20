class Question < ApplicationRecord
  has_many :answers, -> { order(best: :desc) }, inverse_of: :question, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
end
