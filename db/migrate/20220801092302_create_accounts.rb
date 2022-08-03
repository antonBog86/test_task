# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    # id is going to be used by user to send payment. Default id gives too much info due to autoincrement
    # no reaction to duplication of value(very low chance) - overkill for test task
    create_table :accounts, id: :string, limit: 36, null: false do |t|
      t.belongs_to :user, index: true, null: false

      t.float :balance, default: 0.0
      t.float :blocked_balance, default: 0.0

      t.timestamps
    end
  end
end
