#!/usr/bin/env ruby

# fixgenres.rb
# list iTunes track data

libdir = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'itunes'
require 'allmusic'
require 'cache'
require 'ruby-progressbar' # https://github.com/jfelchner/ruby-progressbar/wiki

itunes = Itunes.new
$cache = Cache.new

progressbar = ProgressBar.create(
  :format => '%e |%b>>%i| %p%% %t',
  :title => "Albums",
  :total => itunes.albums.count)

# retrieve album metadata, either from the cache or from allmusic
def get_metadata( album )
  genres = nil
  styles = nil
  if $cache.exists? album
    genres = $cache.genres album
    styles = $cache.styles album
  else
    allmusic = Allmusic.new album.artist, album.title
    allmusic.get_meta
    genres = allmusic.genres
    styles = allmusic.styles
    $cache.update album, genres, styles
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
    # album.genre = new_genre
    progressbar.log "#{album.artist}, '#{album.title}' -> #{new_genre}"
  end
end
