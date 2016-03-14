#!/usr/bin/env ruby
#
# = Album
#
# Copyright 2016 Richard Lyon
# Distributed under the MIT license
#

require_relative 'track'

class Album
  attr_accessor :artist
  attr_accessor :title
  attr_accessor :tracks

  def initialize( artist = nil, title = nil, tracks = [])
    @artist = artist
    @title = title
    @tracks = tracks
  end

  def genre
    if unique?( "genre" )
      return @tracks[0].genre
    else
      return 'mixed'
    end
  end

  def genre=(str)
    @tracks.each do |track|
      track.genre = str
    end
  end

  def unique?( parameter_name )
    values = []
    @tracks.each do |track|
      values << track.send( parameter_name )
    end
    return values.uniq.length == 1
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
end
