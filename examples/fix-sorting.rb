#!/usr/bin/env ruby

# fix_sorting.rb

# Ruby script to correct iTunes sorting issues. Force 'artist sort' to be
# 'artist'. Then reformat "A Perfect Circle" as "Perfect Circle, A". Do the
# same for "The ..". Ignore artists of more than MAX_ARTIST_WORDS as it's
# likely this won't work.

# (c) Richard Lyon 15 March, 2016

MAX_ARTIST_WORDS = 3
libdir = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'ruby-progressbar' # https://github.com/jfelchner/ruby-progressbar/wiki
require 'itunes'
itunes = Itunes.new

# reject tracks with more than MAX_ARTIST_WORDS words in the artist
tracks = itunes.tracks.select { |track| track.artist.split(" ").count <= MAX_ARTIST_WORDS }

progressbar = ProgressBar.create(
:format => '%e |%b>>%i| %p%% %t',
:title => "Tracks",
:total => tracks.count)

# main loop
tracks.each do |track|
  progressbar.increment
  track.sort_album = ""
  track.sort_album_artist = ""
  # if match = track.artist.match(/(A |The )(.*)/)
  #   # e.g. "A Perfect Circle" -> "Perfect Circle, A"
  #   article, title = match.captures
  #   track.sort_artist = "#{title}, #{article}"
  # else
  #   track.sort_artist = track.artist
  # end

end
