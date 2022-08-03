# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    sender factory: :account
    receiver factory: :account

    amount { rand(10) }
  end
end
