# frozen_string_literal: true

module Operations
  module Transactions
    class Create < BaseService
      def initialize(params, sender)
        @params = params
        @sender = sender
      end

      def call
        block_coins

        return transaction unless valid?

        ActiveRecord::Base.transaction do
          create!
          update_balance!
          schedule_processing
        end

        transaction
      end

      private

      attr_reader :params, :sender

      def valid?
        # in case of a large project i'd avoid using default rails validations - they are not flexible enough
        # i'd use something like dry-validations
        # though in current situation complex solutions is overkill

        Validators::Transaction.call(transaction, sender_account)
      end

      def block_coins
        sender_account.blocked_balance = sender_account.blocked_balance + transaction.amount
      end

      def transaction
        @transaction ||= Transaction.new params.to_h.merge(default_params)
      end

      def sender_account
        @sender_account ||= sender.account
      end

      def update_balance!
        sender_account.save!
      end

      def create!
        transaction.save!
      end

      def default_params
        { sender_id: sender_account.id, status: Transaction::STATUSES[:pending] }
      end

      def schedule_processing
        ProcessTransactionJob.perform_later transaction.id
      end
    end
  end
end
