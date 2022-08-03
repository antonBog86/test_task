# frozen_string_literal: true

class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Operations::Transactions::Create.call(permitted_params, current_user)

    if @transaction.persisted?
      redirect_to action: :index
    else
      render :new
    end
  end

  private

  def permitted_params
    params.require(:transaction).permit(:receiver_id, :amount)
  end
end
