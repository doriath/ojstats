source 'http://rubygems.org'

gem 'nokogiri'
gem 'rails', '3.2.11'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'rails-backbone'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'jquery-qtip2-rails'
  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails'
  gem 'bootstrap-datepicker-rails'
end

gem 'mongoid', '~> 3.0'
gem 'bson_ext'
gem 'devise'

gem 'haml-rails'
gem 'simple_form'
gem 'jquery-rails'

gem 'typhoeus'
gem 'gravatar_image_tag'

gem 'thin'
gem 'whenever', require: false

gem 'airbrake'
gem 'newrelic_rpm'
gem 'newrelic_moped'

gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'

group :development do
  gem 'quiet_assets'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'yard-cucumber'
  gem 'yard-rails'
  gem 'awesome_print'

  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-jasmine'
  gem 'rb-fsevent', require: false
  gem 'growl'
  gem 'rb-readline'

  gem 'capistrano', '2.15.5'
  gem 'capistrano_colors'

  gem 'rails_best_practices'
end

group :test, :development do
  # Unit tests
  gem 'rspec-rails'

  # Acceptance tests
  gem 'cucumber-rails', require: false
  gem 'capybara'
  gem 'database_cleaner'

  # Javascript tests
  gem "jasminerice"

  # Common
  gem 'simplecov', require: false
  gem 'fabrication'
  gem 'timecop'
end
