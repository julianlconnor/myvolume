desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  if Time.now.hour == 4 # run at 4am
    Chart.fetch_charts
  end
end