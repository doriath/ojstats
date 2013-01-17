set :output, '/srv/www/ojstats/shared/log/cron.log'

every 1.hour do
  rake 'ranking:refresh'
end

every :sunday, at: '12am' do
  rake 'ranking:refresh_all'
end
