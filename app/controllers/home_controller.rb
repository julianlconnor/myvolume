require 'rubygems'
require 'set'
require 'open-uri'
require 'net/http'
require 'mysql'

class HomeController < ApplicationController
  def index
    #Genre.fetch_genres
    # Chart.fetch_charts
    # TopDownload.fetch_top_downloads
    # @charts = Chart.order("publish_date desc").limit(10)
    @user = User.new
    # if current_user
    #   favorite
    # end
    @charts = Chart.paginate :page => params[:chart_page], :order => "publish_date desc"
    @topdownloads = TopDownload.paginate :page => params[:top_download_page], :order => "rank asc"
    @mostLoved = Song.find(:all, :limit => 10, :order => "favorite_count DESC, created_at DESC")
    @mostActive = mergeActiveAuthUsers()
  end
  
  def playtrack
    @song = Song.find(params[:id])
    #debugger
  end
  
  def mergeActiveAuthUsers
    @u = User.find(:all, :limit=>5, :order => "favorite_count DESC")
    @a = Authorization.find(:all, :limit => 5, :order => "favorite_count DESC")
    @a = @a + @u
    @a = @a.sort {|x,y| x.favorite_count <=> y.favorite_count}.reverse
  end
  
  def top_downloads_paginate
    @topdownloads = TopDownload.paginate :page => params[:page], :order => "rank asc"
  end
  def charts_paginate
    @charts = Chart.paginate :page => params[:chart_page], :order => "publish_date desc"
  end
end
