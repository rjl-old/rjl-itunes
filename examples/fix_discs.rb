#!/usr/bin/env ruby

# fix_discs.rb

# Ruby script to collapse albums. Identifies tracks with 'Album Name (disc 1)',
# 'Album Name (disc 2)' and rename to 'Album Name'.
# TODO check disc numbers are correct before collapsing.

# (c) Richard Lyon 15 March, 2016

libdir = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'itunes'
itunes = Itunes.new

interesting_tracks = []
itunes.albums.each do |album|
  album.tracks.each do |track|
    interesting_tracks << track if track.album.include? "(disc"
  end
end

interesting_tracks.each do |track|
  album_root, discard = track.album.split(" (")
  puts "#{track.album} -> #{album_root}"
  track.album = album_root
end
