#!/usr/bin/env ruby

# rjl_itunes.rb
# get albums and cache data

libdir = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

ITUNES_PATH_TEST = '/Users/richardlyon/Music/Ruby-iTunes/iTunes Library.xml'
ITUNES_PATH_LIVE = '/Users/richardlyon/Music/iCloud-Music-Library/iTunes Library.xml'

require 'itunes'
require 'allmusic'
require 'yaml'
require 'cache'

$cache = Cache.new

# get albums from iTunes
puts "> Opening #{ITUNES_PATH_TEST}"
itunes = Itunes.new ITUNES_PATH_TEST

# retrieve genres and styles, either from the cache or allmusic.com
# returns tuple (genres, styles) as lists of strings
def get_metadata( album )
  genres = nil
  styles = nil
  # check if it's cached
  if $cache.exists? album
    # if it is, get the data from the cache
    puts "> Retrieving from cache"
    genres = $cache.genres album
    styles = $cache.styles album
  else
    # otherwise, get metatdata from allmusic and cache
    puts "> Retrieving from allmusic.com"
    allmusic = Allmusic.new album.artist, album.album
    allmusic.get_meta
    genres = allmusic.genres
    styles = allmusic.styles
    # cache the data
    $cache.update album, genres, styles
  end
  return genres, styles
end

# for each track
itunes.albums.each do |album|
  puts "> Processing #{album.artist} / #{album.album}"
  genres, styles = get_metadata( album )
  # update genre and grouping TODO - improve this algorithm
  album.genre = "#{genres[0]}[#{styles[0]}]"
  # album.grouping = styles[0]
end
