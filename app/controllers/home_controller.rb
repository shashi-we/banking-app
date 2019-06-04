class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index; end

  def dashboard
    @transactions = current_user.bank_transactions
  end
end
  