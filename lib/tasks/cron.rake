desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  if Time.now.hour == 4 # run at 4am
    puts "Running cron at #{Time.now.strftime('%Y/%m/%d %H:%M:%S')}..."
    Chart.fetch_charts
    TopDownload.fetch_top_downloads
  end
end