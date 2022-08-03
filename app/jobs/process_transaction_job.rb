# frozen_string_literal: true

class ProcessTransactionJob < ApplicationJob
  sidekiq_options queue: :default, retry: ENV.fetch('SIDEKIQ_RETRY', 1).to_i

  def perform(transaction_id)
    Operations::Transactions::Process.call(transaction_id)
  end
end
