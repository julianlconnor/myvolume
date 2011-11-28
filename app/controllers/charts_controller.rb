class ChartsController < ApplicationController
  #attr_accessible 
  before_filter :authenticate
  load_and_authorize_resource :only => [:index]
  # GET /charts
  # GET /charts.xml
  def authenticate
    if !current_user
      flash[:error] = "You must log in to see that page."
      redirect_to root_path
    end
  end

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
    @data = @chart = Chart.find(params[:id])
    @data['songs'] = @chart.songs

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
  
  # GET /charts/new
  # GET /charts/new.xml
  def new
    @chart = Chart.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @chart }
    end
  end

  # GET /charts/1/edit
  def edit
    @chart = Chart.find(params[:id])
  end

  # POST /charts
  # POST /charts.xml
  def create
    @chart = Chart.new(params[:chart])

    respond_to do |format|
      if @chart.save
        format.html { redirect_to(@chart, :notice => 'Chart was successfully created.') }
        format.xml  { render :xml => @chart, :status => :created, :location => @chart }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @chart.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /charts/1
  # PUT /charts/1.xml
  def update
    @chart = Chart.find(params[:id])

    respond_to do |format|
      if @chart.update_attributes(params[:chart])
        format.html { redirect_to(@chart, :notice => 'Chart was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @chart.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /charts/1
  # DELETE /charts/1.xml
  def destroy
    @chart = Chart.find(params[:id])
    @chart.destroy

    respond_to do |format|
      format.html { redirect_to(charts_url) }
      format.xml  { head :ok }
    end
  end
end
