require 'rubygems'
require 'open-uri'
require 'net/http'
require 'mysql'

class HomeController < ApplicationController
  def index
    # fetch_genres()
    # fetch_charts()
    @charts = Chart.order("publish_date desc").limit(10)
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
  
  def fetch_charts
    json_out = {}
    # Fetch Chart Overview JSON from Beatport
    chart_overview_fetch = Net::HTTP.get_response(URI.parse("http://api.beatport.com/catalog/charts/overview?format=json&v=1.0"))
    chart_overview_data = chart_overview_fetch.body
    chart_overview = JSON.parse(chart_overview_data)
    # Iterate through new charts
    chart_overview["results"]["newest"].each do |newest|

      # Fetch Chart Detail with newest.id
      chart_detail_fetch = Net::HTTP.get_response(URI.parse("http://api.beatport.com/catalog/charts/detail?id=#{newest["id"]}&format=json&v=1.0"))
      chart_detail_data = chart_detail_fetch.body
      chart_detail = JSON.parse(chart_detail_data)

      #print "#{newest["name"]} ~ #{newest["description"].gsub('\n','')}\n"
      chart_object = Chart.first(:conditions => {:name => newest["name"]})

      if chart_object.nil?
        chart_object = Chart.new(:name => newest["name"], :beatport_id => newest["id"], 
                                 :description => newest["description"], :publish_date => newest["publishDate"])
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
            track["artists"].each do |artist|
              if artist["type"] == "Artist"
                type = "Artist"
                if artists == ""
                  artists = "#{artist["name"]}"
                else
                  artists = artists + " #{artist["name"]} &"
                end
              else artist["type"] == "Remixer"
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
                membership_object = Membership.new(:artist_id => artist_object.id, :song_id => song_object.id, :type => type)
                membership_object.save
              # already exists
              else
                #  add membership between song and artist
                membership_object = Membership.new(:artist_id => @artist_object.id, :song_id => song_object.id, :type => type)
                membership_object.save
              end
            end
            2.times { artists = artists.chop }
            song_object.artist = artists
            song_object.remixer = remixer
            song_object.save
            begin
              song_thumb_object = SongThumbnail.new(:song_id => song_object.id, :small => track["images"]["small"]["url"], :medium => track["images"]["medium"]["url"], :large => track["images"]["large"]["url"])
              song_thumb_object.save
            rescue
            end
          end
        end
      end
      chart_overview["results"]["featured"].each do |newest|

        # Fetch Chart Detail with newest.id
        chart_detail_fetch = Net::HTTP.get_response(URI.parse("http://api.beatport.com/catalog/charts/detail?id=#{newest["id"]}&format=json&v=1.0"))
        chart_detail_data = chart_detail_fetch.body
        chart_detail = JSON.parse(chart_detail_data)

        #print "#{newest["name"]} ~ #{newest["description"].gsub('\n','')}\n"
        chart_object = Chart.first(:conditions => {:name => newest["name"]})

        if chart_object.nil?
          chart_object = Chart.new(:name => newest["name"], :beatport_id => newest["id"], 
                                   :description => newest["description"], :publish_date => newest["publishDate"])
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
              track["artists"].each do |artist|
                if artist["type"] == "Artist"
                  type = "Artist"
                  if artists == ""
                    artists = "#{artist["name"]}"
                  else
                    artists = artists + " #{artist["name"]} &"
                  end
                else artist["type"] == "Remixer"
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
                  membership_object = Membership.new(:artist_id => artist_object.id, :song_id => song_object.id, :type => type)
                  membership_object.save
                # already exists
                else
                  #  add membership between song and artist
                  membership_object = Membership.new(:artist_id => @artist_object.id, :song_id => song_object.id, :type => type)
                  membership_object.save
                end
              end
              2.times { artists = artists.chop }
              song_object.artist = artists
              song_object.remixer = remixer
              song_object.save
              if !song_object.nil? and !track["images"].nil?
                song_thumb_object = SongThumbnail.new(:song_id => song_object.id, :small => track["images"]["small"]["url"], :medium => track["images"]["medium"]["url"], :large => track["images"]["large"]["url"])
                song_thumb_object.save
              end
            end
          end
        end
      end
    end
  end
  
end
