Rails.application.configure do
  # rails server, separate thread
  config.good_job.execution_mode = :async
  # separate $ worker (for production)
  # config.good_job.execution_mode = :external
end
