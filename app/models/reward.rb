class Reward < ApplicationRecord
  has_one_attached :image

  belongs_to :question, dependent: :destroy
  belongs_to :user, optional: true

  validates :title, :image, presence: true
end
