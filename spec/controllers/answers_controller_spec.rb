RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question) }

  describe 'GET #show' do
    let(:answer) { create(:answer) }

    before { get :show, params: { id: answer.id } }

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'show needed answer' do
      expect(assigns(:answer)).to eq answer
    end
  end

  describe 'POST #create' do
    let(:valid_response) do
      post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js }
    end

    context 'with valid params' do
      before { login(user) }

      it 'saves a new answer to database' do
        expect { valid_response }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        valid_response
        expect(response).to render_template :create
      end
    end

    context 'with invalid params' do
      before { login(user) }

      let(:invalid_response) do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid), format: :js }
      end

      it "doesn't save the answer to database" do
        expect { invalid_response }.not_to change(question.answers, :count)
      end

      it 'renders create template' do
        invalid_response
        expect(response).to render_template :create
      end
    end

    context 'when unauthorized user try to create a new answer' do
      it 'does not save the answer to database' do
        expect { valid_response }.not_to change(question.answers, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question) }
    let(:valid_response) { patch :update, params: { id: answer, answer: { body: 'updated body' } }, format: :js }
    let(:invalid_response) do
      patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
    end

    context 'when author tries to edit own answer' do
      before { login author }

      context 'with valid params' do
        before { valid_response }

        it 'changes answer attributes' do
          expect(answer.reload.body).to eq 'updated body'
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid params' do
        it 'does not update the answer in database' do
          expect { invalid_response }.not_to change(answer, :body)
        end

        it 'renders update view' do
          invalid_response
          expect(response).to render_template :update
        end
      end
    end

    context 'when another user tries to edit the answer' do
      before { login(user) }

      it 'does not update the answer in database' do
        expect { valid_response }.not_to change(answer, :body)
      end
    end

    context 'when unauthorized user try to update answer' do
      it 'does not update the answer in database' do
        expect { valid_response }.not_to change(answer, :body)
      end
    end
  end

  describe 'POST #destroy' do
    let!(:answer) { create(:answer, user: author) }

    before { login(author) }

    context 'when author tries to destroy own answer' do
      let(:answer_destroy) { delete :destroy, params: { id: answer.id }, format: :js }

      it 'deletes the answer from database' do
        expect { answer_destroy }.to change(author.answers, :count).by(-1)
      end

      it 'render destroy template' do
        answer_destroy

        expect(response).to render_template :destroy
      end
    end

    context 'when another user tries to destroy the answer' do
      before { login(user) }
      let(:answer_destroy_no_js) { delete :destroy, params: { id: answer } }

      it 'not deletes the answer from database' do
        expect { answer_destroy_no_js }.not_to change(author.answers, :count)
      end

      it 'return forbidden status' do
        answer_destroy_no_js

        expect(response).to have_http_status :forbidden
      end
    end
  end

  describe 'PATCH #set_best' do
    let(:question) { create(:question, user: author) }
    let!(:answer) { create(:answer, user: author, question: question) }

    context 'when author setting the best answer' do
      let(:author) { create(:user) }
      let(:valid_response) { patch :set_best, params: { id: answer }, format: :js }

      before do
        login author
        valid_response
      end

      it 'set as best answer' do
        expect(answer.reload).to be_best
      end

      it 're-render set_best template' do
        expect(response).to render_template :set_best
      end
    end

    context 'when another user trying to set the best answer' do
      let(:user) { create(:user) }
      let(:valid_response_no_js) { patch :set_best, params: { id: answer } }

      before do
        login user
        valid_response_no_js
      end

      it 'does not set as best answer' do
        expect(answer.reload).not_to be_best
      end

      it 'return forbidden status' do
        expect(response).to have_http_status :forbidden
      end
    end

    context 'when unauthorized user trying to set the best answer' do
      let(:valid_response_no_js) { patch :set_best, params: { id: answer } }
      it 'does not set as best answer' do
        expect { valid_response_no_js }.not_to change(answer, :best)
      end
    end
  end
end
