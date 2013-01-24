set :output, '/srv/www/ojstats/shared/log/cron.log'

every 1.hour do
  rake 'ranking:refresh'
end

every :sunday, at: '12:30am' do
  rake 'ranking:refresh_all'
end
