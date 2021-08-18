class Answer < ApplicationRecord
  belongs_to :question

  validates :text, :correct, presence: true
end
