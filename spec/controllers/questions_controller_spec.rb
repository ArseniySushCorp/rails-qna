RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:author) { create(:user) }

  describe 'GET /#index' do
    let(:questions) { create_list(:question, 5) }

    before { get :index }

    it 'renders index view' do
      expect(response).to render_template :index
    end

    it 'show questions list' do
      expect(assigns(:questions)).to match_array(questions)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'show needed question' do
      expect(assigns(:question)).to eq question
    end
  end

  describe 'GET #new' do
    before do
      login(user)
      get :new
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid params' do
      let(:valid_response) { post :create, params: { question: attributes_for(:question) } }

      it 'saves a new question to database' do
        expect { valid_response }.to change(Question, :count).by(1)
      end

      it 'redirects to the question' do
        valid_response
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid params' do
      let(:invalid_response) { post :create, params: { question: attributes_for(:question, :invalid) } }

      it "doesn't save the question to database" do
        expect { invalid_response }.not_to change(Question, :count)
      end

      it 're-render new view' do
        invalid_response
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question) }
    let(:valid_response) { patch :update, params: { id: question, question: { title: 'updated title' } }, format: :js }
    let(:invalid_response) { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

    context 'when author tries to edit own question' do
      before { login author }

      context 'with valid params' do
        before { valid_response }

        it 'changes question attributes' do
          question.reload

          expect(question.title).to eq 'updated title'
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid params' do
        it 'does not update the question in database' do
          expect { invalid_response }.not_to change(question, :title)
        end

        it 'renders update view' do
          invalid_response
          expect(response).to render_template :update
        end
      end
    end

    context 'when another user tries to edit the question' do
      before { login(user) }

      it 'does not update the question in database' do
        expect { valid_response }.not_to change(question, :title)
      end
    end

    context 'when unauthorized user try to update question' do
      it 'does not update the question in database' do
        expect { valid_response }.not_to change(question, :title)
      end
    end
  end

  describe 'POST #destroy' do
    let!(:question) { create(:question, user: author) }
    let(:question_destroy) { delete :destroy, params: { id: question.id } }

    before { login(author) }

    context 'when author tries to destroy own question' do
      it 'deletes the question from database' do
        expect { question_destroy }.to change(author.questions, :count).by(-1)
      end

      it 'redirects to the questions_path' do
        question_destroy

        expect(response).to redirect_to questions_path
      end
    end

    context 'when another user tries to destroy the question' do
      before { login(user) }

      it 'not deletes the question from database' do
        expect { question_destroy }.not_to change(author.questions, :count)
      end

      it 'redirects to the questions_path' do
        question_destroy

        expect(response).to redirect_to questions_path
      end
    end
  end
end
