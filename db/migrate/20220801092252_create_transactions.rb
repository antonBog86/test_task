# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :sender_id,                                        null: false, index: true, limit: 36
      t.string :receiver_id,                                      null: false, index: true, limit: 36
      t.string :status, default: Transaction::STATUSES[:pending], null: false
      t.float  :amount,                                           null: false
      t.text   :fail_reason, limit: 1000

      t.timestamps
    end
  end
end
