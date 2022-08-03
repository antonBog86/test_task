# frozen_string_literal: true

module Validators
  module Account
    class Existence < ActiveModel::Validator
      def validate(record)
        return true if ::Account.exists?(id: record.public_send(options[:attribute]))

        record.errors.add options[:attribute], I18n.t('validators.default')
      end
    end
  end
end
