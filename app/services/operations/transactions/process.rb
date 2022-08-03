# frozen_string_literal: true

module Operations
  module Transactions
    class Process < BaseService
      def initialize(transaction_id)
        @transaction = Transaction.find(transaction_id)
      end

      def call
        validate

        ActiveRecord::Base.transaction do
          change_sender_balance!
          change_receiver_balance!
          update_transaction!
        end
      end

      private

      attr_reader :transaction

      def validate
        return if Validators::Transaction.call(transaction, sender)

        raise TransactionNotValidError.new(messages: transaction.errors.messages)
      end

      def update_transaction!
        transaction.update!(status: Transaction::STATUSES[:success], fail_reason: nil)
      end

      def sender
        @sender ||= transaction.sender
      end

      def change_sender_balance!
        sender.balance = sender.balance - transaction.amount
        sender.blocked_balance = sender.blocked_balance - transaction.amount
        sender.save!
      end

      def change_receiver_balance!
        receiver = transaction.receiver
        receiver.balance = receiver.balance + transaction.amount
        receiver.save!
      end
    end
  end
end
