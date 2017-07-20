# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

if ENV['RAILS_RELATIVE_URL_ROOT']
  map ENV['RAILS_RELATIVE_URL_ROOT'] do
    run Rails.application
    error_logger = ActiveSupport::Logger.new("log/error.log")
    error_logger.level = Logger::ERROR
    Rails.logger.extend ActiveSupport::Logger.broadcast(error_logger)
  end
else
  run Rails.application
  error_logger = ActiveSupport::Logger.new("log/error.log")
  error_logger.level = Logger::ERROR
  Rails.logger.extend ActiveSupport::Logger.broadcast(error_logger)
end