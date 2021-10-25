class Question < ApplicationRecord
  include Votable    

  belongs_to :user

  has_one :reward, dependent: :destroy

  has_many :answers, -> { order(best: :desc) }, inverse_of: :question, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files

  accepts_nested_attributes_for :links, :reward, reject_if: :all_blank

  validates :title, :body, presence: true
end
