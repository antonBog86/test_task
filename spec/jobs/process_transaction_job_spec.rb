# frozen_string_literal: true

RSpec.describe ProcessTransactionJob, type: :job do
  let(:params) { '1' }

  describe '#perform_later' do
    it do
      expect { described_class.perform_later(params) }.to have_enqueued_job
    end
  end

  describe '#perform' do
    it do
      expect(Operations::Transactions::Process).to receive(:call).with(params)

      described_class.perform_now(params)
    end
  end
end
