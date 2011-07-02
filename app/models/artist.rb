class Artist < ActiveRecord::Base
  
  has_many :memberships
  has_many :songs, :through => :memberships
  
  has_one :artist_thumbnail
  
  # I haven't completed writing this function
  
  def self.fill_artist_info(artist_list)
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
    # End routine
  end
  
end
