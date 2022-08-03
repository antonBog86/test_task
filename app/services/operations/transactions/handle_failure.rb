# frozen_string_literal: true

module Operations
  module Transactions
    class HandleFailure < BaseService
      def initialize(job_args, error_message)
        # job args is array - even if you send one parameter in it
        @transaction = Transaction.find(job_args.first)
        @error_message = error_message
      end

      def call
        ActiveRecord::Base.transaction do
          fail_transaction!
          return_coins_to_owner!
        end
      end

      private

      attr_reader :transaction, :error_message

      def fail_transaction!
        transaction.update! fail_reason: error_message, status: Transaction::STATUSES[:failed]
      end

      def return_coins_to_owner!
        ActiveRecord::Base.connection.execute sql_str(transaction.sender_id, transaction.amount)
      end

      def sql_str(id, amount_to_change)
        "UPDATE accounts SET blocked_balance = blocked_balance - #{amount_to_change} WHERE id = '#{id}'"
      end
    end
  end
end
