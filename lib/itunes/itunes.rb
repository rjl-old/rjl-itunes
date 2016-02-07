#!/usr/bin/env ruby
#
# = itunes
#
# Copyright 2016 Richard Lyon
# Distributed under the MIT license
#

require 'plist' # https://github.com/bleything/plist

class Itunes

  attr_reader :album
  attr_reader :tracks_hash
  attr_reader :itunes_plist

  ITUNES_PATH = '/Users/richlyon/Music/iTunes/iTunes Music Library.xml'
  LIVE = '/Users/richlyon/Music/iTunes LIVE DO NOT DELETE/iTunes Music Library.xml'

  attr_reader :itunes_path

  def initialize( itunes_path = ITUNES_PATH )
    @itunes_path = itunes_path
    @itunes_hash = Plist::parse_xml( ITUNES_PATH )
    @tracks_hash = get_audio_tracks
  end

  def save
    File.open(@filepath, 'w') {|f| f.write( itunes.to_plist) }
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

  def get_albums
    album = {
      "artist" => "ABBA",
      "album"  => "Gold"
    }
    return [album]
  end


  def get_first_album
    return "ACDC"
  end
end
