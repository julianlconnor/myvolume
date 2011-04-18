require 'rubygems'
require 'set'
require 'open-uri'
require 'net/http'
require 'mysql'

class HomeController < ApplicationController
  def index
    # Genre.fetch_genres
    # Chart.fetch_charts
    # @charts = Chart.order("publish_date desc").limit(10)
    @charts = Chart.paginate :page => params[:page], :order => "publish_date desc"
  end
end
