class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def assign_as_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
