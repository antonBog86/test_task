# frozen_string_literal: true

RSpec.describe Operations::Accounts::Create do
  describe '.call' do
    subject(:account) do
      described_class.call(user:)
    end

    let(:user) { create(:user) }

    context 'successfully created' do
      specify { expect { account }.to change(Account, :count).by(1) }

      context 'with correct default values' do
        specify { expect(account.id.length).to eq 36 }

        specify { expect(account.balance).to eq 0 }
        specify { expect(account.blocked_balance).to eq 0 }
      end
    end
  end
end
