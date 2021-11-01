# Preview all emails at http://localhost:3000/rails/mailers/question_subsciption
class QuestionSubsciptionPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/question_subsciption/digest
  def digest
    DailyDigestMailer.digest
  end
end