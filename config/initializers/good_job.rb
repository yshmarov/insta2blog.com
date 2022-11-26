Rails.application.configure do
  # rails server, separate thread. development default
  # config.good_job.execution_mode = :async

  # separate $ worker (for production)
  # config.good_job.execution_mode = :external

  # test env
  # config.good_job.execution_mode = :inline
  config.good_job.inline_execution_respects_schedule = true

  config.good_job.enable_cron = true
  config.good_job.cron = {
    weekly_sunday: {
      cron: '0 0 * * 0',
      class: "RefreshExpiringInstaTokensJob"
    }
  }
end
