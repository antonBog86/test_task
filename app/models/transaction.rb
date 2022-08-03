# frozen_string_literal: true

class Transaction < ApplicationRecord
  STATUSES = {
    pending: 'pending',
    success: 'success',
    failed: 'failed'
  }.freeze

  belongs_to :sender, class_name: 'Account'
  belongs_to :receiver, class_name: 'Account'
end
