# frozen_string_literal: true

module Validators
  class Transaction < BaseService
    def initialize(transaction, account)
      @transaction = transaction
      @account = account
    end

    def call
      check_existence_of_receiver
      check_balance

      transaction.errors.none?
    end

    private

    attr_reader :transaction, :account

    def check_existence_of_receiver
      Validators::Account::Existence.new(attribute: :receiver_id).validate(transaction)
    end

    def check_balance
      Validators::Account::PositiveBalance.new(account:, attribute: :amount).validate(transaction)
    end
  end
end
