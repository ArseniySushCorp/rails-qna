RSpec.describe AttachmentsController, type: :controller do
  describe 'POST #delete_attachment' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, :with_file) }

    context 'when author tries to delete own question attachment' do
      let(:delete_file) { delete :destroy, params: { id: question.files.first }, format: :js }

      before { login(question.user) }

      it 'delete file' do
        expect { delete_file }.to change(ActiveStorage::Attachment, :count).by(-1)
      end
    end

    context 'when another user tries delete question attachment' do
      let(:valid_response_no_js) { delete :destroy, params: { id: question.files.first } }

      before { login(user) }

      it 'not delete file' do
        expect { valid_response_no_js }.not_to change(ActiveStorage::Attachment, :count)
      end
    end
  end
end
