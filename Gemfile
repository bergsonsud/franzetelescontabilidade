source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.0'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false



gem 'time_diff'

gem 'will_paginate', '~> 3.0.6'
gem 'will_paginate-bootstrap'
gem 'ransack'


gem 'jquery-rails'
gem 'bootstrap-sass', '~> 3.3.6'

gem 'maskmoney-rails'
gem "font-awesome-rails"
gem 'bootstrap-datepicker-rails'#, git:'https:/github.com/Nerian/bootstrap-datepicker-rails'

gem 'brazilian-rails'
gem 'devise'
gem 'prawn'
gem 'prawn-table'
gem 'pdfkit'
gem 'wkhtmltopdf-binary'
gem 'rails-jquery-autocomplete'
gem 'jquery-ui-rails'

gem 'bcrypt', '~> 3.1.13'

gem 'coffee-rails', '~> 5.0.0'
gem 'bootstrap-glyphicons'
gem 'glyphicons-rails', '~> 0.1.2'

gem 'bootstrap',  '~>4.3.1'

#https://stackoverflow.com/questions/66919504/your-bundle-is-locked-to-mimemagic-0-3-5-but-that-version-could-not-be-found
gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'
gem 'unicorn'
gem 'execjs'
gem 'therubyracer', :platforms => :ruby

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'dotenv'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
