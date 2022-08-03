# frozen_string_literal: true

RSpec.describe 'Transactions', type: :request do
  describe 'GET /show' do
    let(:amount) { 1 }
    let(:receiver) { create(:account) }
    let(:user) { create(:account, balance: 10).user }

    it do
      sign_in user

      # rubocop:disable Style/BlockDelimiters
      expect {
        post '/transactions', params: { transaction: { receiver_id: receiver.id, amount: } }
      }.to change(Transaction, :count).by(1)
      # rubocop:enable Style/BlockDelimiters
    end
  end
end
