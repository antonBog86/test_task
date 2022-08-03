# frozen_string_literal: true

module Operations
  module Accounts
    class Create < BaseService
      def initialize(user:)
        @user = user
      end

      def call
        Account.create(user:, id: uuid)
      end

      private

      attr_reader :user

      def uuid
        SecureRandom.uuid
      end
    end
  end
end
