require 'rubygems'
require 'open-uri'
require 'net/http'
require 'mysql'

class ApiController < ApplicationController
  def fetch_new_charts
    json_out = {}
    # Fetch Chart Overview JSON from Beatport
    chart_overview_fetch = Net::HTTP.get_response(URI.parse("http://api.beatport.com/catalog/charts/overview?format=json&v=1.0"))
    chart_overview_data = chart_overview_fetch.body
    chart_overview = JSON.parse(chart_overview_data)

    chart_overview["results"]["newest"].each do |newest|

      # Fetch Chart Detail with newest.id
      chart_detail_fetch = Net::HTTP.get_response(URI.parse("http://api.beatport.com/catalog/charts/detail?id=#{newest["id"]}&format=json&v=1.0"))
      chart_detail_data = chart_detail_fetch.body
      chart_detail = JSON.parse(chart_detail_data)

      print "#{newest["name"]} ~ #{newest["description"].gsub('\n','')}\n"

      artists = ""
      # Iterate through each track of every chart
      chart_detail["results"]["tracks"].each_with_index do |track,i|
        #print "#{i+1}. #{track["artists"]}\n\n"
        track["artists"].each do |artist|
          if artist["type"] == "Artist"
            artists = artists + " #{artist["name"]} &"
          end
        end
        2.times { artists = artists.chop }
        print "#{i+1}. #{track["name"]} (#{track["mixName"]}) - #{artists}\n"
      end

      #print "id:#{newest["id"]} ~ #{newest["name"]} ~ #{newest["description"].gsub('\n','')}\n"
    end
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
        subgenre_object = Sub_genre.new(:name => subgenre["name"], :slug => subgenre["slug"], :genre_id => genre_object.id)
      end
    end
    
    respond_to do |format|
      format.html { render "home#index" }
    end
    
  end
end
