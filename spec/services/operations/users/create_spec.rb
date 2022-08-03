# frozen_string_literal: true

RSpec.describe Operations::Users::Create do
  describe '.call' do
    subject(:user) do
      described_class.call(user_attributes)
    end

    let(:user_attributes) { attributes_for(:user) }

    context 'successfully created' do
      specify { expect { user }.to change(Account, :count).by(1) }
      specify { expect { user }.to change(User, :count).by(1) }
    end
  end
end
