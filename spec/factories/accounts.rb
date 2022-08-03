# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    initialize_with { Operations::Accounts::Create.call(user: create(:user)) }
  end
end
