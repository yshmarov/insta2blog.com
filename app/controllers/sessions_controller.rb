class SessionsController < ApplicationController
  def logout
    reset_session
    redirect_to root_url, notice: t('.success')
  end
end
