require 'rubygems'
require 'set'
require 'open-uri'
require 'net/http'
require 'mysql'

class HomeController < ApplicationController
  def index
    #fetch_genres()
    # fetch_charts()
    # @charts = Chart.order("publish_date desc").limit(10)
    @charts = Chart.paginate :page => params[:page], :order => "publish_date desc"
  end
  
  def fill_artist_info(artist_list)
    artist_detail_fetch = Net::HTTP.get_response(URI.parse("http://api.beatport.com/catalog/artists?format=json&v=1.0&id=#{artist_list.join(",")}"));
    artist_detail_data = artist_detail_fetch.body
    artist_detail = JSON.parse(artist_detail_data)
    # Loop through artists
    artist_detail["results"].each do |artist|
      # Look up the artist
      # Keep in mind that artist is JSON hash & @artist is db record
      @artist = Artist.first(:conditions => {:beatport_id => artist["id"]})
      if !@artist.nil?
        @artist.last_publish_date = artist["lastPublishDate"]
        @artist.bio = artist["biography"]
        @artist.save
        # Look up thumbnail, see if entry needs to be created or updated
        @artist_thumbnail = ArtistThumbnail.first(:conditions => {:artist_id => @artist.id})
        # Only update if thumb urls are different, if one is different, they all will be
        if !@artist_thumbnail.nil? and @artist_thumbnail.medium != artist["images"]["medium"]["url"]
          @artist_thumbnail.small = artist["images"]["small"]["url"]
          @artist_thumbnail.medium = artist["images"]["medium"]["url"]
          @artist_thumbnail.large = artist["images"]["large"]["url"]
          @artist_thumbnail.save
        elsif @artist_thumbnail.nil?
          # Create the entry
          @artist_thumbnail = ArtistThumbnail.new(:artist_id => @artist.id,
                                                  :small => artist["images"]["small"]["url"], 
                                                  :medium => artist["images"]["medium"]["url"],
                                                  :large => artist["images"]["large"]["url"])
          @artist_thumbnail.save
        end
      else
        # Artist didn't exist?
        artist_object = Artist.new(:name => artist["name"],
                                   :beatport_id => artist["id"],
                                   :last_publish_date => artist["lastPublishDate"],
                                   :bio => artist["biography"])
        artist_object.save
        if !artist_object.artist_thumbnail.nil? and artist_object.artist_thumbnail.medium != artist["images"]["medium"]["url"]
          artist_object.artist_thumbnail.small = artist["images"]["small"]["url"]
          artist_object.artist_thumbnail.medium = artist["images"]["medium"]["url"]
          artist_object.artist_thumbnail.large = artist["images"]["large"]["url"]
          artist_object.artist_thumbnail.save
        elsif @artist_thumbnail.nil?
          # Create the entry
          @artist_thumbnail = ArtistThumbnail.new(:artist_id => @artist.id,
                                                  :small => artist["images"]["small"]["url"], 
                                                  :medium => artist["images"]["medium"]["url"],
                                                  :large => artist["images"]["large"]["url"])
          @artist_thumbnail.save
        end
      end
    end
    # End routine ;)
  end
  
  def fetch_genres
    json_out = {}
    # Fetch Chart Overview JSON from Beatport
    genre_overview_fetch = Net::HTTP.get_response(URI.parse("http://api.beatport.com/catalog/genres?subgenres=true&format=json&v=1.0"))
    genre_overview_data = genre_overview_fetch.body
    genre_overview = JSON.parse(genre_overview_data)
    genre_overview["results"].each do |genre|
      genre_object = Genre.new(:name => genre["name"], :slug => genre["slug"])
      genre_object.save
      genre["subgenres"].each do |subgenre|
        subgenre_object = SubGenre.new(:name => subgenre["name"], :slug => subgenre["slug"], :genre_id => genre_object.id)
        subgenre_object.save
      end
    end
  end
  
  def fetch_chart_detail(charts)
    artist_list = []
    charts.each do |chart|
    
      # Fetch Chart Detail with newest.id
      chart_detail_fetch = Net::HTTP.get_response(URI.parse("http://api.beatport.com/catalog/charts/detail?id=#{chart["id"]}&format=json&v=1.0"))
      chart_detail_data = chart_detail_fetch.body
      chart_detail = JSON.parse(chart_detail_data)

      #print "#{newest["name"]} ~ #{newest["description"].gsub('\n','')}\n"
      chart_object = Chart.first(:conditions => {:name => chart["name"]})

      if chart_object.nil?
        chart_object = Chart.new(:name => chart["name"], :beatport_id => chart["id"], 
                                 :description => chart["description"], :publish_date => chart["publishDate"])
        if chart_object.save
          # Iterate through each track of every chart
          chart_thumb_object = ChartThumbnail.new(:chart_id => chart_object.id, :small => chart_detail["results"]["images"]["small"]["url"],
                                              :medium => chart_detail["results"]["images"]["medium"]["url"],
                                              :large => chart_detail["results"]["images"]["large"]["url"])
          chart_thumb_object.save
          chart_detail["results"]["tracks"].each_with_index do |track,i|
            artists = ""
            type = "asdf"
            remixer = ""
            song_object = Song.new(:name => track["name"], :mix_name => track["mixName"], :sample_url => track["sampleUrl"], :beatport_id => track["id"],
                                   :length => track["length"], :release_date => track["releaseDate"], :publish_date => track["publishDate"])
            song_object.save
            chart_membership_object = ChartMembership.new(:song_id => song_object.id, :chart_id => chart_object.id, :pos => i+1)
            chart_membership_object.save
            track["genres"].each do |genre|
              genre_membership_object = GenreMembership.new(:genre_id => genre["id"], :song_id => song_object.id)
              genre_membership_object.save
            end
            artists = []
            track["artists"].each do |artist|
              artist_list << artist["id"]
              artists << artist["name"]
              if artist["type"] == "Artist"
                type = "Artist"
              elsif artist["type"] == "Remixer"
                type = "Remixer"
                remixer = artist["name"]
              end
              # check to see if artist already exists
              @artist_object = Artist.first(:conditions => {:name => artist["name"]})
              # if it doesn't exist
              if @artist_object.nil?
                artist_object = Artist.new(:name => artist["name"], :beatport_id => artist["id"],
                                           :last_publish_date => artist["lastPublishDate"],
                                           :bio => artist["biography"])
                artist_object.save
                # add membership between song and artist
                membership_object = Membership.new(:artist_id => artist_object.id, :song_id => song_object.id, :type => artist["type"])
                membership_object.save
              # already exists
              else
                #  add membership between song and artist
                membership_object = Membership.new(:artist_id => @artist_object.id, :song_id => song_object.id, :type => artist["type"])
                membership_object.save
              end
            end
            song_object.artist = artists.join(' & ')
            song_object.remixer = remixer
            song_object.save
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
    end
    return artist_list
  end
  
  def fetch_charts
    json_out = {}
    artist_list = []
    # Fetch Chart Overview JSON from Beatport
    chart_overview_fetch = Net::HTTP.get_response(URI.parse("http://api.beatport.com/catalog/charts/overview?format=json&v=1.0"))
    chart_overview_data = chart_overview_fetch.body
    chart_overview = JSON.parse(chart_overview_data)
    # Iterate through new charts
    artist_list << fetch_chart_detail(chart_overview["results"]["newest"])
    artist_list << fetch_chart_detail(chart_overview["results"]["featured"])

    # Filter duplicates from artist IDs
    artist_list = artist_list.to_set

    #fill_artist_info(artist_list.to_a)
  end
  
end
