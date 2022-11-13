Rails.application.configure do
  # testing
  config.good_job.inline_execution_respects_schedule = true

  # rails server, separate thread. development default
  # config.good_job.execution_mode = :async

  # separate $ worker (for production)
  # config.good_job.execution_mode = :external

  # test env
  # config.good_job.execution_mode = :inline
end
