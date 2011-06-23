# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110622235902) do

  create_table "artist_thumbnails", :force => true do |t|
    t.integer  "artist_id"
    t.string   "small"
    t.string   "medium"
    t.string   "large"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artist_thumbnails", ["artist_id"], :name => "index_artist_thumbnails_on_artist_id"

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.datetime "last_publish_date"
    t.integer  "beatport_id"
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artists", ["id"], :name => "index_artists_on_id"

  create_table "authorization_favorites", :force => true do |t|
    t.integer  "authorization_id"
    t.integer  "song_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorizations", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "alias"
    t.string   "avatar_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorizations", ["uid"], :name => "index_authorizations_on_uid"

  create_table "chart_genre_memberships", :force => true do |t|
    t.integer "genre_id"
    t.integer "chart_id"
  end

  add_index "chart_genre_memberships", ["chart_id"], :name => "index_chart_genre_memberships_on_chart_id"
  add_index "chart_genre_memberships", ["genre_id"], :name => "index_chart_genre_memberships_on_genre_id"

  create_table "chart_memberships", :force => true do |t|
    t.integer  "song_id"
    t.integer  "chart_id"
    t.integer  "pos"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chart_memberships", ["chart_id"], :name => "index_chart_memberships_on_chart_id"
  add_index "chart_memberships", ["song_id"], :name => "index_chart_memberships_on_song_id"

  create_table "chart_thumbnails", :force => true do |t|
    t.integer  "chart_id"
    t.string   "small"
    t.string   "medium"
    t.string   "large"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chart_thumbnails", ["chart_id"], :name => "index_chart_thumbnails_on_chart_id"

  create_table "charts", :force => true do |t|
    t.string   "name"
    t.integer  "beatport_id"
    t.text     "description"
    t.datetime "publish_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cron_watchers", :force => true do |t|
    t.datetime "last_update"
  end

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "song_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genre_memberships", :force => true do |t|
    t.integer  "genre_id"
    t.integer  "song_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "genre_memberships", ["genre_id"], :name => "index_genre_memberships_on_genre_id"
  add_index "genre_memberships", ["song_id"], :name => "index_genre_memberships_on_song_id"

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "artist_id"
    t.integer  "song_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["artist_id"], :name => "index_memberships_on_artist_id"
  add_index "memberships", ["song_id"], :name => "index_memberships_on_song_id"

  create_table "song_thumbnails", :force => true do |t|
    t.integer  "song_id"
    t.string   "small"
    t.string   "medium"
    t.string   "large"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "song_thumbnails", ["song_id"], :name => "index_song_thumbnails_on_song_id"

  create_table "songs", :force => true do |t|
    t.string   "name"
    t.string   "mix_name"
    t.string   "artist"
    t.string   "remixer"
    t.integer  "label_id"
    t.string   "sample_url"
    t.string   "length"
    t.integer  "beatport_id"
    t.datetime "release_date"
    t.datetime "publish_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank"
    t.integer  "favorite_count", :default => 0
  end

  create_table "sub_genres", :force => true do |t|
    t.integer  "genre_id"
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sub_genres", ["genre_id"], :name => "index_sub_genres_on_genre_id"

  create_table "top_downloads", :force => true do |t|
    t.integer "rank"
    t.integer "song_id"
    t.integer "difference"
  end

  add_index "top_downloads", ["song_id"], :name => "index_top_downloads_on_song_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alias"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end
