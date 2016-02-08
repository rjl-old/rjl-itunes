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
    track_id, track_hash = album_hash.first
    @artist = track_hash["Artist"]
    @album = track_hash["Album"]
    @grouping = track_hash["Grouping"]
    @genre = track_hash["Genre"]
    @album_hash = album_hash
  end

  def genre=( new_genre )
    new_album_hash = {}
    @album_hash.each do |track_id, track_hash|
      track_hash["Genre"] = new_genre
      new_album_hash[track_id] = track_hash
    end

    # update iTunes. Somehow   :(

    @album_hash = new_album_hash
  end

  def grouping=( new_grouping )
    new_album_hash = {}
    @album_hash.each do |track_id, track_hash|
      track_hash["Grouping"] = new_grouping
      new_album_hash[track_id] = track_hash
    end

    # update iTunes. Somehow   :(

    @album_hash = new_album_hash
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

  def update_album( track_id, property, value )
    # get all of the tracks in that album
    tracks = get_related_tracks( track_id )

    # For each track
    tracks.each do |track_id, track_hash|
      # change the property
      @itunes_hash["Tracks"][track_id.to_s][property] = value
    end
  end

  # Return all of the tracks in the same album as the given track
  def get_related_tracks( track_id )
    album_title = @itunes_hash["Tracks"][track_id.to_s]["Album"]
    tracks = @itunes_hash["Tracks"].reject { |key, hash| hash["Album"] != album_title}
    return tracks
  end

  # Return True if all tracks in the same album as the track have the same property
  # Used to check all genres and groupings are the same
  def same?( track_id, property )
    tracks = get_related_tracks track_id
    groupings = []
    tracks.each do |track_id, hash|
      groupings << hash["Grouping"]
    end

    return groupings.all? {|x| x == groupings[0]}
  end

  def save
    File.open(@itunes_path, 'w') {|f| f.write( @itunes_hash.to_plist) }
  end

  def album ( album_id )
    return @tracks_hash[album_id.to_s]
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

  def niceprint( album_id )
    properties = ["Artist", "Album", "Name", "Grouping", "Genre"]
    puts "="*50
    properties.each do |property|
      puts "#{property}:  #{@itunes_hash["Tracks"][album_id.to_s][property]}"
    end
  end
end
