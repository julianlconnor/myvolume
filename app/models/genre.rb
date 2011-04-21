class Genre < ActiveRecord::Base
  has_many :genre_memberships
  has_many :songs, :through => :genre_memberships
  
  has_many :chart_genre_memberships
  has_many :charts, :through => :chart_genre_memberships
  
  has_many :sub_genres
  
  def self.fetch_genres
    json_out = {}
    # Fetch Genre Overview JSON from Beatport
    genre_overview_fetch = Net::HTTP.get_response(URI.parse("http://api.beatport.com/catalog/genres?subgenres=true&format=json&v=1.0"))
    genre_overview_data = genre_overview_fetch.body
    genre_overview = JSON.parse(genre_overview_data)
    
    # Create Genre & Subgenres
    genre_overview["results"].each do |genre|
      genre_object = Genre.first(:conditions => {:name => genre["name"]})
      if genre_object.nil?
        genre_object = Genre.new(:name => genre["name"], :slug => genre["slug"])
        genre_object.save
        genre["subgenres"].each do |subgenre|
          subgenre_object = SubGenre.first(:conditions => {:name => subgenre["name"]})
          if subgenre_object.nil?
            subgenre_object = SubGenre.new(:name => subgenre["name"], :slug => subgenre["slug"], :genre_id => genre_object.id)
            subgenre_object.save
          end
        end
      end
    end
  end
  
end
