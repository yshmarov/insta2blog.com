class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Passwordless::ControllerHelpers

  helper_method :current_user

  private

  def current_user
    @current_user ||= authenticate_by_session(User)
  end

  def require_user!
    return if current_user

    redirect_to root_path, flash: { alert: t('notifications.unauthorized') }
  end
end
