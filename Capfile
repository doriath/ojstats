load 'deploy'
load 'deploy/assets'
Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
require 'bundler/capistrano'
load 'config/deploy'
