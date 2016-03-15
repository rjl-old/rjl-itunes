#!/usr/bin/env ruby
#
# = itunes
#
# Copyright 2016 Richard Lyon
# Distributed under the MIT license
#

require "rb-scpt" # https://github.com/BrendanThompson/rb-scpt
include Appscript
require_relative 'album'

class Itunes

  attr_accessor :albums
  attr_reader   :tags
  def initialize( playlist = nil )
    @tracks = get_tracks( playlist )
    @albums = get_albums(@tracks)
  end

  def get_tracks( playlist = nil)
    track_list = []
    if playlist.nil?
      tracks = app("iTunes").playlists[1].tracks[its.video_kind.eq(:none)].get
    else
      tracks = app("iTunes").playlists[playlist].tracks[its.video_kind.eq(:none)].get
    end
    tracks.each do |track_obj|
      track_list << Track.new(track_obj)
    end
    return track_list
  end

  def make_key( artist, album )
    return "#{artist}/#{album}"
  end

  def get_albums( track_list )
    album_list = []
    tracks_hash = Hash.new { |hash, key| hash[key] = [] }
    track_list.each do |track|
      key = make_key(track.artist, track.album)
      tracks_hash[key] << track
    end
    tracks_hash.each do |key, tracks|
      artist, title = key.split('/')
      album_list << Album.new(artist, title, tracks)
    end
    return album_list
  end
end
