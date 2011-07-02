class Chart < ActiveRecord::Base
  
  has_many :chart_memberships
  has_many :songs, :through => :chart_memberships
  
  has_many :chart_genre_memberships
  has_many :genres, :through => :chart_genre_memberships
  
  has_one :chart_thumbnail
  
  self.per_page = 8
  
  def self.fetch_chart_detail(charts)
    artist_list = []
    charts.each do |chart|
      
      # Fetch Chart Detail with newest.id
      chart_detail_fetch = Net::HTTP.get_response(URI.parse("http://api.beatport.com/catalog/charts/detail?id=#{chart["id"]}&format=json&v=1.0"))
      chart_detail_data = chart_detail_fetch.body
      chart_detail = JSON.parse(chart_detail_data)

      #print "#{newest["name"]} ~ #{newest["description"].gsub('\n','')}\n"
      chart_object = Chart.first(:conditions => {:name => chart["name"]})
      
      # Check to see if chart already exists, and if the chart is older than one year old
      if chart_object.nil?
        chart_object = Chart.new(:name => chart["name"], :beatport_id => chart["id"], 
                                 :description => chart["description"], :publish_date => chart["publishDate"])
        chart_object.save
        chart_detail["results"]["genres"].each do |genre|
          genre_object = Genre.first(:conditions => {:name => genre["name"]})
          # Check to see if the genre exists
          if genre_object.nil?
            genre_object = Genre.new(:name => genre["name"], :slug => genre["slug"])
            genre_object.save
          end
          # Check to see if the membership already exists
          chart_genre_object = ChartGenreMembership.first(:conditions => {:genre_id => genre_object.id, :chart_id => chart_object.id})
          if chart_genre_object.nil?
            chart_genre_object = ChartGenreMembership.new(:chart_id => chart_object.id, :genre_id => genre_object.id)
            chart_genre_object.save
          end
        end
        # Create chart thumbnail
        # Depending on if the call is being made from catalog or overview, the object may not have a large thumbnail
        if chart_detail["results"]["images"]["large"].nil?
          chart_thumb_object = ChartThumbnail.new(:chart_id => chart_object.id, :small => chart_detail["results"]["images"]["small"]["url"],
                                              :medium => chart_detail["results"]["images"]["medium"]["url"])
          chart_thumb_object.save
        elsif !chart_detail["results"]["images"]["large"].nil?
          chart_thumb_object = ChartThumbnail.new(:chart_id => chart_object.id, :small => chart_detail["results"]["images"]["small"]["url"],
                                              :medium => chart_detail["results"]["images"]["medium"]["url"],
                                              :large => chart_detail["results"]["images"]["large"]["url"])
          chart_thumb_object.save
        end
        # Iterate through each track of every chart
        chart_detail["results"]["tracks"].each_with_index do |track,i| 
          artists = ""
          remixer = ""
          # Check to see if the song already exists
          song_object = Song.first(:conditions => {:beatport_id => track["id"]})
          if song_object.nil?
            song_object = Song.new(:name => track["name"], :mix_name => track["mixName"], :sample_url => track["sampleUrl"], :beatport_id => track["id"],
                                   :length => track["length"], :release_date => track["releaseDate"], :publish_date => track["publishDate"])
            song_object.save
          end
          # Create song - chart association 
          chart_membership_object = ChartMembership.new(:song_id => song_object.id, :chart_id => chart_object.id, :pos => i+1)
          chart_membership_object.save
          # Iterate through song genre associations
          track["genres"].each do |genre|
            # Check to see if genre already exists
            genre_object = Genre.first(:conditions => {:name => genre["name"]})
            if genre_object.nil?
              genre_object = Genre.new(:name => genre["name"], :slug => genre["name"])
            end
            # Create song - genre association
            genre_membership_object = GenreMembership.new(:genre_id => genre_object.id, :song_id => song_object.id)
            genre_membership_object.save
          end
          # Loop through the artists
          artists = []
          track["artists"].each do |artist|
            # artist_list is use to fetch more accurate data on each newly added artist
            #I haven't completed this functionality yet
            artist_list << artist["id"]
            artists << artist["name"]
            if artist["type"] == "Remixer"
              remixer = artist["name"]
            end
            # Check to see if artist already exists
            artist_object = Artist.first(:conditions => {:name => artist["name"]})
            # If it doesn't exist
            if artist_object.nil?
              artist_object = Artist.new(:name => artist["name"], :beatport_id => artist["id"], :type => artist["type"],
                                         :last_publish_date => artist["lastPublishDate"],
                                         :bio => artist["biography"])
              artist_object.save
            end
              # Add membership between song and artist
              membership_object = Membership.new(:artist_id => artist_object.id, :song_id => song_object.id, :type => artist["type"])
              membership_object.save
          end
          # Join artist list on ampersand
          #Inefficient, on the list to change
          song_object.artist = artists.join(' & ')
          song_object.remixer = remixer
          song_object.save
          
          # Grab thumbnail information for each song
          song_thumb_object = SongThumbnail.first(:conditions => {:song_id => song_object.id})
          if !song_object.nil? && !track["images"].nil? && !track["images"]["large"].nil?
            song_thumb_object = SongThumbnail.new(:song_id => song_object.id,
                                                  :small => track["images"]["small"]["url"],
                                                  :medium => track["images"]["medium"]["url"],
                                                  :large => track["images"]["large"]["url"])
            song_thumb_object.save
          end
        end
      end
    end
    return artist_list
  end
  
  def self.fetch_charts
    json_out = {}
    artist_list = []
    
    # Fetch Chart Overview JSON from Beatport
    chart_overview_fetch = Net::HTTP.get_response(URI.parse("http://api.beatport.com/catalog/charts/overview?format=json&v=1.0"))
    chart_overview_data = chart_overview_fetch.body
    chart_overview = JSON.parse(chart_overview_data)
    
    # Iterate through newewst & featured charts
    artist_list << fetch_chart_detail(chart_overview["results"]["newest"])
    artist_list << fetch_chart_detail(chart_overview["results"]["featured"])
    
    @genres = Genre.all
       @genres.each do |genre|
         chart_overview_fetch = Net::HTTP.get_response(URI.parse("http://api.beatport.com/catalog/charts?sortBy=publishDate%20desc,chartId%20desc&genreId=#{genre.id}&perPage=5&page=1&format=json&v=1.0"))
         chart_overview_data = chart_overview_fetch.body
         chart_overview = JSON.parse(chart_overview_data)
         artist_list << fetch_chart_detail(chart_overview["results"])
       end
    # Filter duplicates from artist IDs
    artist_list = artist_list.to_set
    
    # Update last_update
    cron_watcher_object = CronWatcher.new(:last_update => Time.now)
    cron_watcher_object.save
    
    #fill_artist_info(artist_list.to_a)
  end
  
end
