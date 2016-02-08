#!/usr/bin/env ruby
#
# = itunes
#
# Copyright 2016 Richard Lyon
# Distributed under the MIT license
#

require 'plist' # https://github.com/bleything/plist


class Itunes

  ITUNES_PATH = '/Users/richlyon/Music/iTunes/iTunes Music Library.xml'
  LIVE = '/Users/richlyon/Music/iTunes LIVE DO NOT DELETE/iTunes Music Library.xml'

  # attr_reader :album
  attr_reader :albums
  attr_reader :tracks_hash
  attr_reader :itunes_plist
  attr_reader :itunes_path
  attr_reader :itunes_hash

  def initialize( itunes_path = ITUNES_PATH )
    @itunes_path = itunes_path
    @itunes_hash = Plist::parse_xml( ITUNES_PATH )
    @tracks_hash = get_audio_tracks
  end

  class Album < Itunes

    attr_accessor :album
    attr_accessor :artist
    attr_accessor :grouping
    attr_accessor :genre

    def initialize( album_title, artist = nil )
      super()
      @album = album_title
      @artist = artist
      @album_tracks_hash = @itunes_hash["Tracks"].reject { |key, hash|
        (hash["Artist"] != artist) || (hash["Album"] != album_title)
      }
    end

    def get_or_exit property
      if not same? property
        raise "'Tracks have different #{property} for artist #{artist} album #{@album}"
        exit
      else
        album_id, album_hash = @album_tracks_hash.first
        property = album_hash[property]
      end
      return property
    end

    def grouping
      return get_or_exit "Grouping"
    end

    def grouping=( new_grouping )
      @album_tracks_hash.each do |track_id, track_hash|
        @itunes_hash["Tracks"][track_id]["Grouping"] = new_grouping
      end
    end

    def genre
      return get_or_exit "Genre"
    end

    def genre=( new_genre )
      @album_tracks_hash.each do |track_id, track_hash|
        @itunes_hash["Tracks"][track_id]["Genre"] = new_genre
      end
    end

    # return true if tracks all have the same property
    def same? property
      properties = []
      @album_tracks_hash.each do |track_id, track_hash|
        properties << track_hash[property]
      end

      return properties[0] if properties.all? {|x| x == properties[0]}
    end

    def exists?
      return !@album_tracks_hash.empty?
    end
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

  def get_audio_tracks
    tracks = []
    audio_files_hash = @itunes_hash["Tracks"].reject { |key, hash| !audio_file?( hash )}
    audio_files_hash.each do |track_id, track_hash|
      tracks << track_hash
    end
    return audio_files_hash
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
