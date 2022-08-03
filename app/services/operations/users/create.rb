# frozen_string_literal: true

module Operations
  module Users
    class Create < BaseService
      def initialize(user_attributes)
        @user_attributes = user_attributes
      end

      def call
        create_user
        create_account
      end

      private

      def create_user
        @user = User.create(user_attributes)
      end

      def create_account
        Accounts::Create.call(user:)
      end

      attr_reader :user_attributes, :user
    end
  end
end
