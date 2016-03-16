#!/usr/bin/env ruby

# fix_genres.rb

# Ruby script to classify iTunes track genres. Retrieves genre and style
# information from Allmusic.com, computes a genre, and sets track genre to it.
# Insert [protected] in Groupings to exclude tracks from classification.

# (c) Richard Lyon 15 March, 2016

libdir = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'itunes'
require 'allmusic'
require 'ruby-progressbar' # https://github.com/jfelchner/ruby-progressbar/wiki
require 'daybreak'         # http://propublica.github.io/daybreak/

itunes = Itunes.new
$db = Daybreak::DB.new "albums.db", :default => {}

progressbar = ProgressBar.create(
  :format => '%e |%b>>%i| %p%% %t',
  :title => "Tracks",
  :total => itunes.albums.count)

# e.g. "ABBA", "Gold" -> "ABBA__Gold"
def make_key( album_obj)
  return "#{album_obj.artist}__#{album_obj.title}"
end

# retrieve album metadata, either from the cache or from allmusic
def get_metadata( album )
  genres = nil
  styles = nil
  album_key = make_key( album )
  if $db[album_key].any?
    # p "#{$db[album_key]}"
    genres = $db[album_key][:genres]
    styles = $db[album_key][:styles]
  else
    allmusic = Allmusic.new album.artist, album.title
    genres = allmusic.genres
    styles = allmusic.styles
    metadata = { :genres => genres, :styles => styles }
    $db[album_key] = metadata
    $db.flush
  end
  return genres, styles
end

# make the genre string e.g. "Jazz [Guitar Jazz]"
# TODO improve this algorith e.g. select most frequent
def build_genre( genres, styles )
  genre = ("" if genres.nil?) || genres[0]
  style = ("" if styles.nil?) || styles[0]
  return "#{genre} [#{style}]"
end

# main loop - fix album genre unless tagged 'proteected'
itunes.albums.each do |album|
  progressbar.increment
  unless album.protected?
    genres, styles = get_metadata( album )
    new_genre = build_genre( genres, styles )
    album.genre = new_genre
    progressbar.log "#{album.artist}, '#{album.title}' -> #{new_genre}"
  end
end

$db.close
