#!/usr/bin/env ruby
#
# = itunes
#
# Copyright 2016 Richard Lyon
# Distributed under the MIT license
#

require 'plist' # https://github.com/bleything/plist

class Album

  attr_reader   :artist
  attr_reader   :album
  attr_accessor :grouping
  attr_accessor :genre

  attr_reader   :album_hash

  def initialize album_hash
    @album_hash = album_hash
    parse_album_hash
  end

  def parse_album_hash
    track_id, track_hash = album_hash.first
    @artist = track_hash["Artist"]
    @album = track_hash["Album"]
    @grouping = track_hash["Grouping"]
    @genre = track_hash["Genre"]
  end

  def genre=( new_genre )
    new_album_hash = {}
    @album_hash.each do |track_id, track_hash|
      track_hash["Genre"] = new_genre
      new_album_hash[track_id] = track_hash
    end
    @album_hash = new_album_hash
    parse_album_hash
    # update iTunes. Somehow   :(
  end

  def grouping=( new_grouping )
    new_album_hash = {}
    @album_hash.each do |track_id, track_hash|
      track_hash["Grouping"] = new_grouping
      new_album_hash[track_id] = track_hash
    end
    @album_hash = new_album_hash
    parse_album_hash
    # update iTunes. Somehow   :(
  end
end

class Itunes

  TEST_ITUNES_PATH = '/Users/richlyon/Coding/Ruby/development/rjl_itunes/features/assets/test/iTunes Music Library.xml'
  ITUNES_PATH = '/Users/richlyon/Music/iTunes/iTunes Music Library.xml'
  LIVE = '/Users/richlyon/Music/iTunes LIVE DO NOT DELETE/iTunes Music Library.xml'

  # attr_reader :album
  attr_reader :albums
  attr_reader :tracks_hash
  attr_reader :itunes_plist
  attr_reader :itunes_path
  attr_reader :itunes_hash

  def initialize( itunes_path = TEST_ITUNES_PATH )
    @itunes_path = itunes_path
    @itunes_hash = Plist::parse_xml( ITUNES_PATH )
    @tracks_hash = get_audio_tracks
    @albums = get_albums
  end

  def get_audio_tracks
    tracks = []
    audio_files_hash = @itunes_hash["Tracks"].reject { |key, hash| !audio_file?( hash )}
    audio_files_hash.each do |track_id, track_hash|
      tracks << track_hash
    end
    return audio_files_hash
  end

  def get_albums
    titles = []
    @tracks_hash.first(1).each do |album_id, album_hash|
      titles << album_hash["Album"] if !titles.include? album_hash["Album"]
    end

    albums_list = []
    titles.each do |title|
      tracks = {}
      @tracks_hash.each do |album_id, album_hash|
        tracks[album_id] = album_hash if title == album_hash["Album"]
      end
      albums_list << Album.new(tracks)
    end
    return albums_list
  end

  def save
    File.open(@itunes_path, 'w') {|f| f.write( @itunes_hash.to_plist) }
  end

  def valid?
    return !@itunes_hash.nil?
  end

  def audio_file?( track_hash )
    return track_hash["Kind"].include? "audio file"
  end

  def debug( message )
    puts "="*100
    puts message
    puts "="*100
  end
end
