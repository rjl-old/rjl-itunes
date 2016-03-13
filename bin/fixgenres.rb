#!/usr/bin/env ruby

# tracklister.rb
# list iTunes track data

libdir = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

TEST = '/Users/richardlyon/Music/Ruby-iTunes/iTunes Library.xml'
LIVE = '/Users/richardlyon/Music/iCloud-Music-Library/iTunes Library.xml'

require 'itunes'
require 'allmusic'
require 'cache'
require 'YAML'

itunes = Itunes.new LIVE
$cache = Cache.new

def get_metadata( album )
  genres = nil
  styles = nil
  # check if it's cached
  if $cache.exists? album
    # if it is, get the data from the cache
    puts "  Retrieving from cache"
    genres = $cache.genres album
    styles = $cache.styles album
  else
    # otherwise, get metatdata from allmusic and cache
    puts "  Retrieving from allmusic.com"
    allmusic = Allmusic.new album.artist, album.title
    allmusic.get_meta
    genres = allmusic.genres
    styles = allmusic.styles
    # cache the data
    $cache.update album, genres, styles
  end
  return genres, styles
end

def build_genre( genres, styles )
  genre = ("" if genres.nil?) || genres[0]
  style = ("" if styles.nil?) || styles[0]
  return "#{genre} [#{style}]"
end

itunes.albums.each do |album|
  puts "> Processing #{album.long_name}"
  genres, styles = get_metadata( album )
  new_genre = build_genre( genres, styles )
  puts "  Genres: #{genres}"
  puts "  Styles: #{styles}"
  puts "  New   : #{new_genre} "

  album.genre = new_genre

end
