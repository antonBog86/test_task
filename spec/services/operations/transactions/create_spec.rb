# frozen_string_literal: true

RSpec.describe Operations::Transactions::Create do
  describe '.call' do
    subject(:transaction) do
      described_class.call(params, sender.user)
    end

    let(:sender) { create(:account, balance: 5) }
    let(:receiver) { create(:account) }
    let(:amount) { 1 }
    let(:params) { { receiver_id: receiver.id, amount: } }

    context 'when successfully created' do
      specify { expect { transaction }.to change(Transaction, :count).by(1) }

      context 'with correct values in db' do
        specify { expect(transaction.amount).to eq params[:amount] }

        specify { expect(transaction.status).to eq Transaction::STATUSES[:pending] }
        specify { expect(transaction.sender_id).to eq sender.id }
        specify { expect(transaction.receiver_id).to eq params[:receiver_id] }

        it 'balance for sender should not change' do
          transaction

          initial_sender = sender
          expect(sender.reload.balance).to eq initial_sender.balance
        end

        it 'blocked_balance for sender should change by expected amount' do
          transaction

          expect(sender.reload.blocked_balance).to eq params[:amount]
        end
      end
    end

    context 'when failed' do
      context 'by absence of coins' do
        let(:amount) { 10 }

        specify { expect { transaction }.to change(Transaction, :count).by(0) }

        it 'call validator' do
          expect(Validators::Transaction).to receive(:call).once

          transaction
        end
      end

      context 'by non existent receiver' do
        let(:params) { { receiver_id: 'random letters here', amount: } }

        specify { expect { transaction }.to change(Transaction, :count).by(0) }
      end
    end

    context 'when failed at the end of transaction' do
      before do
        allow_any_instance_of(described_class).to receive(:schedule_processing).and_raise(StandardError)
      end

      it 'no data saved before point of failure is kept in db' do
        expect { transaction }.to raise_error(StandardError)
        expect(Transaction.count).to eq(0)
        expect(sender.reload.blocked_balance).to eq(0)
      end
    end
  end
end
