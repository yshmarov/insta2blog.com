class PwaController < ActionController::Base
  skip_forgery_protection

  def service_worker
    render template: "pwa/service-worker", layout: false
  end

  def manifest
    render template: "pwa/manifest", layout: false
  end
end