class TopDownload < ActiveRecord::Base
  belongs_to :song
  
  self.per_page = 15
  # Still need to fix difference, overriding other tracks so some data is lost
  #One way to fix this would be to push rank info to the song db, then check that for non nil and do the proper shizz
  def self.fetch_top_downloads
    # Fetch Genre Overview JSON from Beatport
    download_overview_fetch = Net::HTTP.get_response(URI.parse("http://api.beatport.com/catalog/most-popular?format=json&v=1.0&perPage=50&page=1"))
    download_overview_data = download_overview_fetch.body
    download_overview = JSON.parse(download_overview_data)
    
    # Iterate through tracks in the download list
    download_overview["results"].each do |track|
      # See if the song exists already
      song_object = Song.first(:conditions => {:beatport_id => track["id"]})
      # If song does not exist
      if song_object.nil?
        # Create the song
        song_object = Song.new(:name => track["name"], :mix_name => track["mixName"], :sample_url => track["sampleUrl"], :beatport_id => track["id"],
                               :length => track["length"], :release_date => track["releaseDate"], :publish_date => track["publishDate"], :rank => track["position"])
        song_object.save
        # Iterate through song genre associations
        track["genres"].each do |genre|
          # Check to see if genre already exists
          genre_object = Genre.first(:conditions => {:name => genre["name"]})
          if genre_object.nil?
            genre_object = Genre.new(:name => genre["name"], :slug => genre["name"])
          end
          # Create song - genre association
          # Check to see if membership already exists
          genre_membership_object = GenreMembership.first(:conditions => {:genre_id => genre_object.id, :song_id => song_object.id})
          if genre_membership_object.nil?
            genre_membership_object = GenreMembership.new(:genre_id => genre_object.id, :song_id => song_object.id)
            genre_membership_object.save
          end
        end
        # Loop through the artists
        artists = []
        remixer = ""
        track["artists"].each do |artist|
          # artist_list is use to fetch more accurate data on each newly added artist
          #I haven't completed this functionality yet
          artists << artist["name"]
          if artist["type"] == "Remixer"
            remixer = artist["name"]
          end
          # Check to see if artist already exists
          artist_object = Artist.first(:conditions => {:name => artist["name"]})
          # If it doesn't exist
          if artist_object.nil?
            artist_object = Artist.new(:name => artist["name"], :beatport_id => artist["id"],
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
      # Now we have a song object no matter what, see if it's in the download spot
      # Check to see if that song exists in the topdownloads
      top_download_object = TopDownload.first(:conditions => {:song_id => song_object.id})
      if top_download_object.nil? and song_object.rank.nil?
        # Song doesn't exist in the charts, and its rank is null, truly new
        # Replace the object at that position with its new information
        song_object.rank = track["position"]
        top_download_object = TopDownload.first(:conditions => {:rank => track["position"]})
        if top_download_object.nil?
          # The object truly doesn't exist (first run through)
          top_download_object = TopDownload.new(:rank => track["position"], :song_id => song_object.id, :difference => 0)
        else
          top_download_object.song_id = song_object.id
          top_download_object.difference = 0
        end
      elsif top_download_object.nil?
        # Song doesn't exist but has a rank of what it was previously
        # Occurs when a song is overwritten while fetching new tracks
        #Meaning, a song moved (up or down) into this song's position
        top_download_object = TopDownload.first(:conditions => {:rank => track["position"]})
        if top_download_object.nil?
          # The object truly doesn't exist (first run through)
          top_download_object = TopDownload.new(:rank => track["position"], :song_id => song_object.id, :difference => 0)
        else
          top_download_object.song_id = song_object.id
          top_download_object.difference = song_object.rank - track["position"]
          song_object.rank = track["position"]
        end
      else
        # Song already exists
        previous_rank = top_download_object.rank
        # replace the object at that position with its new information
        top_download_object = TopDownload.first(:conditions => {:rank => track["position"]})
        if top_download_object.nil?
          # The object truly doesn't exist (first run through)
          top_download_object = TopDownload.new(:rank => track["position"], :song_id => song_object.id, :difference => 0)
        else
          top_download_object.song_id = song_object.id
          top_download_object.difference = previous_rank - track["position"]
          song_object.rank = track["position"]
        end
      end
      top_download_object.save
      song_object.save
    end
    
  end
  
  
end
