class ChartsController < ApplicationController
  #attr_accessible 
  # GET /charts
  # GET /charts.xml

  def snippet(title, wordcount)  
    title.split[0..(wordcount-1)].join(" ") + (title.split.size > wordcount ? "..." : "") 
  end

  def index
    if !params[:top].nil?
      @charts = Chart.where("id <= :id",{:id => params[:top]}).paginate(:page => params[:page], :order => "publish_date desc")
    else
      @charts = Chart.paginate(:page => params[:page], :order => "publish_date desc")
    end

    
    @data = []
    @charts.each do |chart|
      @thumbnails = {"thumbnail_small"=>chart.chart_thumbnail.small, "thumbnail_medium"=>chart.chart_thumbnail.medium, "name_truncated" => snippet(chart.name,4)}
      @genres = {"genres"=> chart.genres.map {|genre| genre.name }}
      @data << chart.attributes.merge!(@thumbnails).merge!(@genres)
    end

    render :json => @data.to_json
  end

  def charts_paginate
    @charts = Chart.paginate :page => params[:chart_page], :order => "publish_date desc"
  end

  # GET /charts/1
  # Will is the best!
  # GET /charts/1.xml
  def show
    @chart = Chart.find(params[:id])
    @data = @chart.songs.map { |song| song.attributes }

    render :json => @data.to_json
  end

  def top_downloads
    @topdownloads = TopDownload.paginate :page => params[:page], :order => "rank asc"
    @data = []
    @topdownloads.each {|td| @data << td.song }

    render :json => @data.to_json
  end
  
  def showSongs
    @songs = Chart.find(params[:id]).songs
    
    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.xml  { render :xml => @songs }
    end
  end
end
