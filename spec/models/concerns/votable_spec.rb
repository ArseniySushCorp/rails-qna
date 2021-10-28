describe 'votable' do
  module Votable; end

  context 'with question' do
    with_model :Question do
      model do
        include Votable
      end
    end

    before { Question.create }

    it 'has module' do
      expect(Question.include?(Votable)).to eq true
    end
  end
end
