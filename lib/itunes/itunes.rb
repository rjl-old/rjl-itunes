#!/usr/bin/env ruby
#
# = itunes
#
# Copyright 2016 Richard Lyon
# Distributed under the MIT license
#

require 'plist'    # https://github.com/bleything/plist
require 'pp'       # debugging only
require 'taglib'   # http://robinst.github.io/taglib-ruby/
require 'uri'

class Itunes

  TEST_ITUNES_PATH = '/Users/richardlyon/Coding/Ruby/development/rjl_itunes/features/assets/test/iTunes Music Library.xml'
  LIVE = '/Users/richardlyon/Music/iTunes LIVE DO NOT DELETE/iTunes Music Library.xml'

  # attr_reader :album
  attr_reader :albums
  attr_reader :tracks_hash
  attr_reader :itunes_plist
  attr_reader :itunes_path
  attr_reader :itunes_hash

  class Album < Itunes

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
      # if @album == "Retour - Best of Züri West"
      #   puts track_hash
      #   puts "="*100
      # end
    end

    def genre=( new_genre )
      @genre = new_genre

      # change the genre for each track in the album
      new_album_hash = {}
      @album_hash.each do |track_id, track_hash|
        track_hash["Genre"] = new_genre
        new_album_hash[track_id] = track_hash
      end
      @album_hash = new_album_hash

      # write new genre to filesystem
      @album_hash.each do |track_id, track_hash|
        file_path = URI.decode(track_hash["Location"]).gsub('file://','')
        track = Track.new file_path
        puts file_path
        puts track.genre
        track.genre = new_genre

      end
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

  class Track

    def initialize(filepath)
      @filepath = filepath
    end

    def title
      TagLib::FileRef.open(@filepath) do |fileref|
        tag = fileref.tag
        return tag.title
      end
    end

    def title=(str)
      TagLib::FileRef.open(@filepath) do |fileref|
        tag = fileref.tag
        tag.title = str
        fileref.save
      end
    end

    def genre
      TagLib::FileRef.open(@filepath) do |fileref|
        tag = fileref.tag
        return tag.genre
      end
    end

    def genre=(str)
      TagLib::FileRef.open(@filepath) do |fileref|
        tag = fileref.tag
        tag.genre = str
        fileref.save
      end
    end
  end

  def initialize( itunes_path = TEST_ITUNES_PATH )
    if File.exists? itunes_path
      @itunes_path = itunes_path
      @itunes_hash = Plist::parse_xml( itunes_path )
      @tracks_hash = get_audio_tracks
      @albums = get_albums
    else
      raise "Can't find #{itunes_path}"
    end
  end

  def get_audio_tracks
    audio_files_hash = @itunes_hash["Tracks"].reject { |key, hash| !audio_file?( hash )}
    return audio_files_hash
  end

  def get_albums
    titles = []
    @tracks_hash.each do |album_id, album_hash|
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
    # update @itunes_hash with @albums

    # dump(@itunes_hash, "file_before.txt" )
    # update the albums in itunes_hash with new album data
    @albums.each do |album|
      album.album_hash.each do |track_id, track_hash|
        @itunes_hash["Tracks"][track_id.to_s] = track_hash
      end
    end
    # dump(@itunes_hash, "file_after.txt" )

    # save genre data to ID3 tag


    # save itunes xml
    # File.open(@itunes_path, 'w') {|f| f.write( @itunes_hash.to_plist) }
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

  def dump( a_hash, filename = 'dump' )
    filename = File.join('out/', filename+ '.txt')
    puts ">>> File dumped to #{filename}"
    File.open(filename,'w+') do |f|
      f.write(PP.pp(a_hash,f))
    end
  end
end
