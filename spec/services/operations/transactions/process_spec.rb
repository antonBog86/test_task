# frozen_string_literal: true

RSpec.describe Operations::Transactions::Process do
  describe '.call' do
    subject(:process) do
      described_class.call(transaction.id)
    end

    let(:transaction) { create(:transaction, sender:, amount: transaction_amount) }
    let(:sender) { create(:account, balance: current_balance, blocked_balance: current_b_balance) }
    let(:receiver) { transaction.receiver }
    let(:transaction_amount) { rand(100) }
    let(:current_balance) { transaction_amount + base_amount }
    let(:current_b_balance) { transaction_amount }
    let(:base_amount) { rand(100) }

    context 'when successfully processed' do
      context 'correct values is set in db' do
        before { process }

        specify { expect(transaction.reload.status).to eq Transaction::STATUSES[:success] }
        specify { expect(transaction.reload.fail_reason).to be_nil }

        it 'balance for sender should change' do
          expect(sender.reload.balance).to eq base_amount
        end

        it 'blocked_balance for sender should reset' do
          expect(sender.reload.blocked_balance).to eq 0
        end

        it 'balance for receiver should change' do
          expect(receiver.reload.balance).to eq transaction_amount
        end
      end
    end

    context 'when failed' do
      context 'by absence of coins' do
        let(:sender) { create(:account, blocked_balance: current_balance + transaction_amount + 1) }

        it do
          expect { process }.to raise_error(TransactionNotValidError)
        end
      end
    end

    context 'when failed at the end of transaction' do
      before do
        allow_any_instance_of(described_class).to receive(:update_transaction!).and_raise(StandardError)
      end

      it 'no data saved before point of failure is kept in db' do
        expect { process }.to raise_error(StandardError)
        expect(Transaction.count).to eq(1)
        expect(receiver.reload.balance).to eq(0)
      end
    end
  end
end
