class SongsController < ApplicationController
  #before_filter :authenticate_user!
  # GET /songs
  load_and_authorize_resource :only => [:edit, :create, :update, :destroy]
  # GET /songs.xml
  def index
    @chart = Chart.find(params[:chart_id])

    @data = []
    @chart.songs.each {|song| @data << song.attributes.merge!({"thumbnail_small"=>song.song_thumbnail.small}).merge!({"genre"=>song.genres.first.name})}

    render :json => @data.to_json
  end

  # GET /songs/1
  # GET /songs/1.xml
  def show
    @song = Song.find(params[:id])
  end

  def top_downloads
    @top_downloads = TopDownload.paginate :page => params[:top_download_page], :order => "rank asc"
  end
  # GET /songs/new
  # GET /songs/new.xml
  def new
    @song = Song.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @song }
    end
  end
end
