RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'GET #show' do
    before { get :show, params: { id: answer.id } }

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'show needed answer' do
      expect(assigns(:answer)).to eq answer
    end
  end

  describe 'POST #create' do
    let(:valid_response) { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }

    context 'with valid params' do
      before { login(user) }

      it 'saves a new answer to database' do
        expect { valid_response }.to change(question.answers, :count).by(1)
      end

      it 'redirects to the current answer question' do
        valid_response
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid params' do
      before { login(user) }

      let(:invalid_response) { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) } }

      it "doesn't save the answer to database" do
        expect { invalid_response }.not_to change(question.answers, :count)
      end

      it 'redirect to current question' do
        invalid_response
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'when unauthorized user try to create a new answer' do
      it 'does not save the answer to database' do
        expect { valid_response }.not_to change(question.answers, :count)
      end
    end
  end

  describe 'POST #destroy' do
    let!(:answer) { create(:answer, user: author) }
    let(:answer_destroy) { delete :destroy, params: { id: answer.id } }

    before { login(author) }

    context 'when author tries to destroy own answer' do
      it 'deletes the answer from database' do
        expect { answer_destroy }.to change(author.answers, :count).by(-1)
      end

      it 'redirects to the question_path' do
        answer_destroy

        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'when another user tries to destroy the answer' do
      before { login(user) }

      it 'not deletes the answer from database' do
        expect { answer_destroy }.not_to change(author.answers, :count)
      end

      it 'redirects to the question_path' do
        answer_destroy

        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
