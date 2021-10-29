class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :user_id

  has_many :comments
  has_many :links

  has_many :files, key: :files_url do
    object.files.map do |file|
      file.url
    end
  end
end