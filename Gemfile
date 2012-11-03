source 'https://rubygems.org'

gem 'rails', '3.2.8'

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
gem 'nokogiri'
gem 'gravatar_image_tag'

gem 'thin'
gem 'whenever', require: false

gem 'airbrake'
gem 'newrelic_rpm'
gem 'newrelic_moped'


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

  gem 'capistrano'
  gem 'capistrano_colors'
end

group :test, :development do
  gem 'simplecov', require: false
  gem 'rspec-rails'
  gem 'fabrication'
  gem 'timecop'
  gem "jasminerice"
end
