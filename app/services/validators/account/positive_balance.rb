# frozen_string_literal: true

module Validators
  module Account
    class PositiveBalance < ActiveModel::Validator
      def validate(record)
        return true if options[:account].balance - options[:account].blocked_balance >= 0

        record.errors.add options[:attribute], I18n.t('validators.account.negative_balance')
      end
    end
  end
end
