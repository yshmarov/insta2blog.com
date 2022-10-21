class SessionsController < ApplicationController
  def logout
    reset_session
    redirect_to root_url, notice: 'You have logged out'
  end
end
