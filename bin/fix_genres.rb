#!/usr/bin/env ruby

# fix_genres.rb

# Ruby script to classify iTunes track genres. Retrieves genre and style
# information from Allmusic.com, computes a genre, and sets track genre to it.
# Insert [protected] in Groupings to exclude tracks from classification.

# (c) Richard Lyon 15 March, 2016

$: << File.join(File.dirname(__FILE__), '..', 'lib')
require 'rjl/itunes'

# require 'metadata'
require 'ruby-progressbar' # https://github.com/jfelchner/ruby-progressbar/wiki

itunes = RJL::Itunes.new

progressbar = ProgressBar.create(
  :format => '%e |%b>>%i| %p%% %t',
  :title => "Tracks",
  :total => itunes.albums.count)

# main loop - fix album genre unless tagged 'proteected'
itunes.albums.each do |album|
  metadata = RJL::Metadata.new( album: album )
  progressbar.increment
  unless album.protected?
    new_genre = metadata.genre( album )
    unless new_genre == ""
      album.genre = metadata.genre( album )
      progressbar.log "#{album.album_artist}, '#{album.title}' -> #{new_genre}"
    end
  end
end
