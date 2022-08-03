# frozen_string_literal: true

class AccountsController < ApplicationController
  def show
    @account = current_user.account
  end
end
