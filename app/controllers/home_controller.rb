require 'rubygems'
require 'set'
require 'open-uri'
require 'net/http'
require 'mysql'

class HomeController < ApplicationController
  def index
    #Genre.fetch_genres
    #Chart.fetch_charts
    #TopDownload.fetch_top_downloads
    # @charts = Chart.order("publish_date desc").limit(10)
    @user = User.new
    # if current_user
    #   favorite
    # end
    @charts = Chart.paginate :page => params[:page], :order => "publish_date desc"
    @topdownloads = TopDownload.paginate :page => params[:page], :order => "rank asc"
  end
  
  def top_downloads
    @topdownloads = TopDownload.paginate :page => params[:page], :order => "rank asc"
  end
end
