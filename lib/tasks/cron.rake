desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  if Time.now.hour == 18 # run at midnight
    Chart.fetch_charts
  end
end