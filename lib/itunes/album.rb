#!/usr/bin/env ruby
#
# = Album
#
# Copyright 2016 Richard Lyon
# Distributed under the MIT license
#

require_relative 'track'
require_relative 'utils'

# Represents an album in Apple's 'iTunes' application.
class Album

  attr_reader :album_artist
  attr_reader :title
  attr_accessor :genre
  attr_reader :protected?   # @return [Boolean] is the album protected from changes?
  attr_reader :tracks       # @return [List of Track] the album tracks

  # @param [List of Track] tracks  the tracks
  def initialize( tracks: [])
    @tracks = tracks
  end

  # @return [String artist name] the album artist if only one
  # @return [String 'Various Artists'] if more than one
  def album_artist
    album_artist = nil
    if unique?(@tracks, "artist" )
      album_artist = @tracks[0].artist
    else
      album_artist = 'Various Artists'
    end
    return album_artist
  end

  # @return [String] album title
  def title
    return @tracks[0].album
  end

  # @return [String] album genre
  def genre
    if unique?( @tracks, "genre" )
      return @tracks[0].genre
    else
      return 'mixed'
    end
  end

  # @param [String] album genre
  def genre=(str)
    if !self.protected?
      @tracks.each do |track|
        track.genre = str
      end
    end
  end

  def protected?
    protected = false
    @tracks.each do |track|
      if track.tags.include? 'protected'
        protected = true
        break
      end
    end
    return protected
  end

  def to_s
    puts "-"*50
    puts "> #{@album_artist}, '#{@title}'"
    @tracks.each do |track|
      puts "  #{track.name}"
    end
    puts "="*50
  end
end
