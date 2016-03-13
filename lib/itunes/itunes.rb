#!/usr/bin/env ruby
#
# = itunes
#
# Copyright 2016 Richard Lyon
# Distributed under the MIT license
#

require 'plist'    # https://github.com/bleything/plist
require 'pp'       # debugging only
require_relative 'album'

class Itunes

  TEST_ITUNES_PATH = '/Users/richardlyon/Coding/Ruby/development/rjl_itunes/features/assets/test/iTunes Music Library.xml'
  LIVE = '/Users/richardlyon/Music/iTunes LIVE DO NOT DELETE/iTunes Music Library.xml'

  # attr_reader :album
  attr_reader :itunes_path
  attr_reader :itunes_hash
  attr_reader :albums

  def initialize( itunes_path = TEST_ITUNES_PATH )
    @itunes_path = itunes_path || nil
    @albums = []

    if File.exists? itunes_path
      @itunes_path = itunes_path
      @itunes_hash = Plist::parse_xml( itunes_path )
      @albums = get_albums( @itunes_hash )
    else
      raise "Can't find #{itunes_path}"
    end
  end

  # return string e.g. "A Perfect Circle/Thirteenth Step"
  def make_key( audio_track_hash )
    artist = audio_track_hash["Artist"]
    title = audio_track_hash["Album"]
    return "#{artist}/#{title}"
  end

  # return a list of Album objects
  def get_albums (itunes_hash )
    album_list = []
    # albums.default_proc = proc { [] }
    # filter audio files
    audio_tracks_hash = itunes_hash["Tracks"].reject { |key, hash| !audio_file?( hash )}

    # build list of album keys
    # e.g. ["A Perfect Circle/Thirteenth Step", "Starsailor/Love Is Here"]
    keys = Hash.new
    audio_tracks_hash.each do |track_id, audio_track_hash|
      key = make_key( audio_track_hash )
      keys[key] = "*"
    end
    album_keys_list = keys.keys

    # build list of album tracks
    album_keys_list.each do |album_key|
      track_list = []
      audio_tracks_hash.each do |track_id, audio_track_hash|
        track_list << audio_track_hash if album_key == make_key(audio_track_hash)
      end
      album_list << Album.new(track_list)
    end

    return album_list
  end

  def audio_file?( track_hash )
    return track_hash["Kind"].include? "audio file"
  end

end
