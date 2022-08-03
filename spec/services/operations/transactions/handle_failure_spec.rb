# frozen_string_literal: true

RSpec.describe Operations::Transactions::HandleFailure do
  describe '.call' do
    subject(:process) do
      described_class.call([transaction.id], error_message)
    end

    let(:transaction) { create(:transaction, sender:, amount: transaction_amount) }
    let(:sender) { create(:account, balance: current_balance, blocked_balance: current_b_balance) }
    let(:receiver) { transaction.receiver }
    let(:error_message) { 'any' }
    let(:transaction_amount) { rand(100) }
    let(:current_balance) { transaction_amount + base_amount }
    let(:current_b_balance) { transaction_amount }
    let(:base_amount) { rand(100) }

    context 'when successfully processed' do
      context 'correct values is set in db' do
        before { process }

        specify { expect(transaction.reload.status).to eq Transaction::STATUSES[:failed] }
        specify { expect(transaction.reload.fail_reason).to eq(error_message) }

        it 'balance for sender should not change' do
          expect(sender.reload.balance).to eq current_balance
        end

        it 'blocked_balance for sender should reset' do
          expect(sender.reload.blocked_balance).to eq 0
        end
      end
    end
  end
end
