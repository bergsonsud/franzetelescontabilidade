# This file is used by Rack-based servers to start the application.

require_relative "config/environment"


if ENV['RAILS_RELATIVE_URL_ROOT']
  map '/' do
    run proc { |env|
      [301, { 'Content-Type' => 'text', 'Location' => '/franzetelescontabilidade' }, ['301 Moved Permanently']]
    }
  end
end

map ENV['RAILS_RELATIVE_URL_ROOT'] || '/' do
  run Rails.application
  Rails.application.load_server
end
