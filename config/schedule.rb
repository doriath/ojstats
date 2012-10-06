set :outout, '/srv/www/ojstats/shared/log/cron.log'

every 1.hour do
  rake "ranking:refresh"
end
