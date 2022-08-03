Sidekiq.configure_server do |config|
  config.death_handlers << ->(job, ex) do
    job.fetch('args').each do |args|
      Operations::Transactions::HandleFailure.call(args.fetch('arguments'), ex.message)
    end
  end
end
